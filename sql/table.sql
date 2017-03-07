create database mysql_web;

use mysql_web;

drop table host_infos;
create table host_infos
(
    host_id mediumint unsigned not null auto_increment primary key,
    host varchar(30) not null default '' comment '����ip��ַ��������',
    port smallint unsigned not null default 3306 comment '�˿ں�',
    user varchar(30) not null default 'root' ,
    password varchar(30) not null default '' comment '����',
    remark varchar(100) not null default '' comment '��ע',
    is_master tinyint not null default 0 comment '�Ƿ�������',
    is_slave tinyint not null default 0 comment '�Ƿ��Ǵӿ�',
    master_id mediumint unsigned not null default 0 comment '����Ǵӿ�-�����������id',
    is_deleted tinyint not null default 0 comment 'ɾ���Ľ����ټ��',
    created_time timestamp not null default current_timestamp,
    modified_time timestamp not null default current_timestamp on update current_timestamp
) comment = 'mysql�˻���Ϣ' ;

#insert into host_infos (host, port, user, password, remark) values
#("192.168.11.129", 3306, "yangcg", "yangcaogui", "Master"),
#("192.168.11.130", 3306, "yangcg", "yangcaogui", "Slave");
#insert into host_infos (host, port, user, password, remark) values ("192.168.11.128", 3306, "yangcg", "yangcaogui", "Monitor");
#host_info1 = host_info.HoseInfo("192.168.11.129", 3306, "yangcg", "yangcaogui", "Master")
#host_info2 = host_info.HoseInfo("192.168.11.130", 3306, "yangcg", "yangcaogui", "Slave")
#self.__host_infos[host_info1.key] = host_info1
#self.__host_infos[host_info2.key] = host_info2'''

DROP TABLE mysql_status_log;
CREATE TABLE mysql_status_log
(
    id int UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT UNSIGNED NOT NULL,
    qps MEDIUMINT UNSIGNED NOT NULL,
    tps MEDIUMINT UNSIGNED NOT NULL,
    commit MEDIUMINT UNSIGNED NOT NULL,
    rollback MEDIUMINT UNSIGNED NOT NULL,
    connections MEDIUMINT UNSIGNED NOT NULL,
    thread_count MEDIUMINT UNSIGNED NOT NULL,
    thread_running_count MEDIUMINT UNSIGNED NOT NULL,
    tmp_tables MEDIUMINT UNSIGNED NOT NULL,
    tmp_disk_tables MEDIUMINT UNSIGNED NOT NULL,
    delay_pos INT UNSIGNED NOT NULL DEFAULT 0,
    send_bytes VARCHAR(7) NOT NULL DEFAULT '',
    receive_bytes VARCHAR(7) NOT NULL DEFAULT '',
    created_time TIMESTAMP NOT NULL DEFAULT NOW()
) COMMENT = 'mysql monitor log';

DROP TABLE mysql_enviroment_data;
CREATE TABLE mysql_enviroment_data
(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT UNSIGNED NOT NULL ,
    process_list TEXT NOT NULL DEFAULT '',
    innodb_status TEXT NOT NULL DEFAULT '',
    slave_status TEXT NOT NULL DEFAULT '',
    trx_status TEXT NOT NULL DEFAULT '',
    created_time TIMESTAMP NOT NULL DEFAULT NOW()
) COMMENT = 'mysql envirment data';

CREATE TABLE mysql_host_status_log
(
    id int UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT UNSIGNED NOT NULL,
    cpu SMALLINT UNSIGNED NOT NULL,
    memory SMALLINT UNSIGNED NOT NULL
) COMMENT = 'mysql monitor log';