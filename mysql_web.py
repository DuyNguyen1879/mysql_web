# -*- coding: utf-8 -*-

#yum install openssl-devel  python-devel libffi-devel -y
#pip install flask threadpool pymysql DBUtils paramiko

import enum, settings, sys
from flask import Flask, render_template, request, app, redirect
from monitor import cache, server, slow_log, mysql_status, alarm_thread, tablespace, general_log, execute_sql, user, thread

app = Flask(__name__)

mysql_cache = cache.Cache()
mysql_cache.load_all_host_infos()
monitor_server = server.MonitorServer()
monitor_server.load()
monitor_server.start()
alarm_thread.AlarmLog().start()

reload(sys)
sys.setdefaultencoding('utf8')

#region mysql api

@app.route("/mysql")
def get_mysql_data():
    return render_template("mysqls.html", mysql_infos=mysql_cache.get_all_host_infos())

@app.route("/mysql/<int:id>")
def get_mysql_data_by_id(id):
    return get_monitor_data(data_host=convert_object_to_list(mysql_cache.get_linux_info(id)),
                            data_status=convert_object_to_list(mysql_cache.get_status_infos(id)),
                            data_repl=convert_object_to_list(mysql_cache.get_repl_info(id)),
                            data_innodb=convert_object_to_list(mysql_cache.get_innodb_infos(id)),
                            data_engine_innodb=mysql_cache.get_engine_innodb_status_infos(id))

#endregion

#region mysql status api

@app.route("/status")
def get_status_data():
    return get_monitor_data(data_status=mysql_cache.get_all_status_infos())

@app.route("/status/<int:id>")
def get_status_data_by_id(id):
    return get_monitor_data(data_status=convert_object_to_list(mysql_cache.get_status_infos(id)))

#endregion

#region innodb api

@app.route("/innodb")
def get_innodb_data():
    return get_monitor_data(data_innodb=mysql_cache.get_all_innodb_infos())

@app.route("/innodb/<int:id>")
def get_innodb_data_by_id(id):
    return get_monitor_data(data_innodb=convert_object_to_list(mysql_cache.get_innodb_infos(id)), data_engine_innodb=mysql_cache.get_engine_innodb_status_infos(id))

#endregion

#region replication api

@app.route("/replication")
def get_replication_data():
    return get_monitor_data(data_repl=mysql_cache.get_all_repl_infos())

@app.route("/replication/<int:id>")
def get_replication_data_by_id(id):
    return get_monitor_data(slave_status=mysql_status.get_show_slave_status(id))

#endregion

#region tablespace api

@app.route("/tablespace")
def get_tablespace():
    return get_monitor_data(tablespace_status=mysql_cache.get_all_tablespace_infos())

@app.route("/tablespace/<int:id>")
def get_tablespace_by_id(id):
    return render_template("tablespace.html", table_status=mysql_cache.get_tablespace_info(id).detail[0:50], host_info=mysql_cache.get_host_info(id))

#endregion

#region general log api

@app.route("/general/<int:page_number>")
def get_general_log_by_page_number(page_number):
    if(page_number <= 5):
        page_list = range(1, 10)
    else:
        page_list = range(page_number-5, page_number + 6)
    return render_template("general_log.html", general_logs=general_log.get_general_logs_by_page_index(page_number), page_number=page_number, page_list=page_list)

@app.route("/general/<int:page_number>/detail/<checksum>")
def get_general_log_detail(page_number, checksum):
    return render_template("general_log_detail.html", page_number=page_number, general_log_detail=general_log.get_general_log_detail(checksum))

#endregion

def convert_object_to_list(obj):
    list_tmp = None
    if(obj != None):
        list_tmp = []
        list_tmp.append(obj)
    return list_tmp

def get_monitor_data(data_status=None, data_innodb=None, data_repl=None, data_engine_innodb=None, data_host=None, slave_status=None, tablespace_status=None):
    return render_template("monitor.html", data_engine_innodb=data_engine_innodb, data_status=data_status, data_innodb=data_innodb, data_repl=data_repl, data_host=data_host, slave_status=slave_status, tablespace_status=tablespace_status)

#region slow log api

@app.route("/slowlog")
def get_slow_logs():
    return render_template("slow_log.html", slow_list = slow_log.get_slow_log_top_20(), slow_low_info=None)

@app.route("/slowlog/<checksum>")
def get_slow_log_detail(checksum):
    return render_template("slow_log.html", slow_list = None, slow_low_info=slow_log.get_slow_log_detail(checksum))

#endregion

@app.route("/os")
def get_os_infos():
    return get_monitor_data(data_host=mysql_cache.get_all_linux_infos())

@app.route("/sql")
def execute_sql_home():
    return render_template("execute_sql.html", host_infos=mysql_cache.get_all_host_infos())

@app.route("/autoreview", methods=['GET', 'POST'])
def execute_sql_for_commit():
    #print(request.form)
    return execute_sql.execute_sql_test(request.form["cluster_name"], request.form["sql_content"], request.form["workflow_name"], request.form["is_backup"])

@app.route("/testsql", methods=['GET', 'POST'])
def test_sql():
    return "execute sql ok."

@app.route("/home", methods=['GET', 'POST'])
def home():
    return render_template("home.html", interval=settings.UPDATE_INTERVAL * 1000)

@app.route("/mytest")
def test_tablespace():
    return render_template("user.html", user_infos=user.MySQLUser(1).get_all_users(), host_id=1, host_infos=mysql_cache.get_all_host_infos())

@app.route("/home/chart")
def chart():
    data="[1996-01-02, 22], [1997-02-08, 36], [1996-01-02, 37], [1996-01-02, 45], [1996-01-02, 50], [1996-01-02, 30], [1996-01-02, 61], [1996-01-02, 61], [1996-01-02, 62], [1996-01-02, 66], [1996-01-02, 73]"
    data="[aaa, 22], [bbb, 36], [1996-01-02, 37], [1996-01-02, 45], [1996-01-02, 50], [1996-01-02, 30], [1996-01-02, 61], [1996-01-02, 61], [1996-01-02, 62], [1996-01-02, 66], [1996-01-02, 73]"
    #return render_template("chart.html", p_data=data)
    return render_template("test.html")

@app.route("/home/binlog")
def get_test():
    return render_template("binlog.html")

#region user web api

@app.route("/user")
def user_home():
    return render_template("user.html", host_infos=mysql_cache.get_all_host_infos())

@app.route("/user/query", methods=['GET', 'POST'])
def select_user():
    print(request.form)
    host_id = int(request.form["server_id"])
    return render_template("user_display.html", host_id=host_id, user_infos=user.MySQLUser(host_id).query_user(request.form["user_name"], request.form["ip"]))

@app.route("/user/db")
def get_all_database_name():
    return user.MySQLUser(1).get_all_database_name()

@app.route("/user/<name>/<ip>")
def get_detail_priv_by_user(name, ip):
    return user.MySQLUser(1).get_privs_by_user(name, ip)

@app.route("/user/detail/<int:host_id>/<name>/<ip>")
def get_user_detail(host_id, name, ip):
    return user.MySQLUser(host_id).get_privs_by_user(name, ip)

@app.route("/user/add")
def add_user():
    pass

@app.route("/user/drop/<int:host_id>/<name>/<ip>")
def drop_user(host_id, name, ip):
    return user.MySQLUser(host_id).drop_user(name, ip)

#endregion

#region thread api

@app.route("/thread")
def thread_home():
    return render_template("thread.html", host_infos=mysql_cache.get_all_host_infos())

@app.route("/thread/<int:host_id>")
def get_thread_infos(host_id):
    return render_template("thread_display.html", thread_infos=thread.get_all_thread(host_id))

#endregion

if __name__ == '__main__':
    #app.run(threaded=True)
    app.run(debug=True, host="0.0.0.0", port=int("5000"))
