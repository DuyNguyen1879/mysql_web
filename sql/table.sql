create database mysql_web;

use mysql_web;

#mysql�˻���Ϣ��
drop table host_infos;
create table host_infos
(
    host_id mediumint unsigned not null auto_increment primary key,
    host varchar(30) not null default '' comment '����ip��ַ��������',
    port smallint unsigned not null default 3306 comment '�˿ں�',
    user varchar(30) not null default 'root' ,
    password varchar(40) not null default '' comment '����',
    remark varchar(100) not null default '' comment '��ע',
    is_master tinyint not null default 0 comment '�Ƿ�������',
    is_slave tinyint not null default 0 comment '�Ƿ��Ǵӿ�',
    master_id mediumint unsigned not null default 0 comment '����Ǵӿ�-�����������id',
    ssh_user VARCHAR(20) NOT NULL DEFAULT 'root' COMMENT 'sshԶ��ִ��������û���Ĭ����root',
    ssh_port SMALLINT UNSIGNED NOT NULL DEFAULT 22 COMMENT '����sshԶ��ִ�еĶ˿�',
    ssh_password VARCHAR(100) NOT NULL DEFAULT '' COMMENT '��������������¼����Ҫ��������',
    is_deleted tinyint not null default 0 comment 'ɾ���Ľ����ټ��',
    created_time timestamp not null default current_timestamp,
    modified_time timestamp not null default current_timestamp on update current_timestamp,
    UNIQUE KEY idx_host_ip (`host`, `port`) COMMENT 'ip��ַ�Ͷ˿ں�Ψһ��'
) comment = 'mysql�˻���Ϣ' CHARSET utf8 ENGINE innodb;

#insert into host_infos (host, port, user, password, remark) values ("192.168.11.128", 3306, "yangcg", "yangcaogui", "Monitor");

DROP TABLE mysql_status_log;
CREATE TABLE mysql_status_log
(
    id int UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT UNSIGNED NOT NULL,
    qps MEDIUMINT UNSIGNED NOT NULL,
    tps MEDIUMINT UNSIGNED NOT NULL,
    trxs MEDIUMINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ÿ����������',
    commit MEDIUMINT UNSIGNED NOT NULL,
    rollback MEDIUMINT UNSIGNED NOT NULL,
    connections MEDIUMINT UNSIGNED NOT NULL,
    thread_count MEDIUMINT UNSIGNED NOT NULL,
    thread_running_count MEDIUMINT UNSIGNED NOT NULL,
    tmp_tables MEDIUMINT UNSIGNED NOT NULL,
    tmp_disk_tables MEDIUMINT UNSIGNED NOT NULL,
    delay_pos INT UNSIGNED NOT NULL DEFAULT 0,
    send_bytes INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��С��λ�ֽ�',
    receive_bytes INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��С��λ�ֽ�',
    created_time TIMESTAMP NOT NULL DEFAULT NOW(),
    key idx_hostId_createdTime (`host_id`, `created_time`)
) COMMENT = 'mysql�����־' CHARSET utf8 ENGINE innodb;

DROP TABLE os_monitor_data;
CREATE TABLE os_monitor_data
(
    id int UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '',
    cpu1 FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��λ�ٷֱ�%',
    cpu5 FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��λ�ٷֱ�%',
    cpu15 FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��λ�ٷֱ�%',
    cpu_user FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��λ�ٷֱ�%',
    cpu_sys FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��λ�ٷֱ�%',
    cpu_iowait FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��λ�ٷֱ�%',
    mysql_cpu FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��λ�ٷֱ�%',
    mysql_memory FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��λ�ٷֱ�%',
    mysql_size SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'mysql���ݴ�С����λΪG',
    io_qps SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '',
    io_tps SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '',
    io_read FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ioÿ���ȡ���ݣ���λKB',
    io_write FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ioÿ��д�����ݣ���λKB',
    io_util FLOAT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ioʹ���ʣ�Խ��˵��ioԽ��æ',
    created_time TIMESTAMP NOT NULL DEFAULT NOW(),
    key idx_hostId_createdTime (`host_id`, `created_time`)
) COMMENT = 'linux�����������־' CHARSET utf8 ENGINE innodb;

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

CREATE TABLE mysql_data_size_for_day
(
    id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT NOT NULL,
    data_size_incr BIGINT UNSIGNED NOT NULL DEFAULT 0,
    index_size_incr BIGINT UNSIGNED NOT NULL DEFAULT 0,
    rows_incr INT UNSIGNED NOT NULL DEFAULT 0,
    auto_increment_incr INT UNSIGNED NOT NULL DEFAULT 0,
    file_size_incr BIGINT UNSIGNED NOT NULL DEFAULT 0,
    created_time TIMESTAMP NOT NULL DEFAULT NOW()
) COMMENT = 'mysql data size log';

DROP TABLE mysql_data_size_for_day;
CREATE TABLE mysql_data_size_for_day
(
    id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT NOT NULL,
    data_size_incr BIGINT UNSIGNED NOT NULL DEFAULT 0,
    index_size_incr BIGINT UNSIGNED NOT NULL DEFAULT 0,
    rows_incr INT UNSIGNED NOT NULL DEFAULT 0,
    auto_increment_incr INT UNSIGNED NOT NULL DEFAULT 0,
    file_size_incr BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `date` DATE NOT NULL,
    created_time TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE KEY idx_host_id_date(host_id, `date`)
) COMMENT = 'mysql data size log';

DROP TABLE mysql_data_total_size_log;
CREATE TABLE mysql_data_total_size_log
(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT NOT NULL,
    rows_t BIGINT UNSIGNED NOT NULL DEFAULT 0,
    data_t BIGINT UNSIGNED NOT NULL DEFAULT 0,
    index_t BIGINT UNSIGNED NOT NULL DEFAULT 0,
    all_t BIGINT UNSIGNED NOT NULL DEFAULT 0,
    file_t BIGINT UNSIGNED NOT NULL DEFAULT 0,
    free_t BIGINT UNSIGNED NOT NULL DEFAULT 0,
    table_count SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    `date` DATE NOT NULL,
    created_time TIMESTAMP NOT NULL DEFAULT NOW(),
    KEY idx_hostId_date(host_id, `date`)
) COMMENT = '���ݿ��С���ܱ�';

DROP TABLE mysql_data_size_log;
CREATE TABLE mysql_data_size_log
(
    id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT NOT NULL,
    `schema` VARCHAR(50) NOT NULL DEFAULT '',
    table_name VARCHAR(80) NOT NULL DEFAULT '',
    data_size BIGINT UNSIGNED NOT NULL DEFAULT 0,
    index_size BIGINT UNSIGNED NOT NULL DEFAULT 0,
    total_size BIGINT UNSIGNED NOT NULL DEFAULT 0,
    rows INT UNSIGNED NOT NULL DEFAULT 0,
    auto_increment BIGINT UNSIGNED NOT NULL DEFAULT 0,
    file_size BIGINT UNSIGNED NOT NULL DEFAULT 0,
    free_size BIGINT NOT NULL DEFAULT 0,
    `date` DATE NOT NULL,
    created_time TIMESTAMP NOT NULL DEFAULT NOW(),
    KEY idx_hostId_date(host_id, `date`)
) COMMENT = '���ݿ����Ϣ���ܱ�';

#�쳣��¼��
DROP TABLE mysql_exception;
CREATE TABLE mysql_exception
(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT NOT NULL,
    exception_type TINYINT UNSIGNED NOT NULL DEFAULT 0,
    log_type TINYINT UNSIGNED NOT NULL DEFAULT 0,
    level TINYINT UNSIGNED NOT NULL,
    created_time TIMESTAMP NOT NULL DEFAULT NOW()
) COMMENT = 'mysql exception';

#�쳣��Ϣ��ϸ��
DROP TABLE mysql_exception_log;
CREATE TABLE mysql_exception_log
(
    id INT UNSIGNED NOT NULL PRIMARY KEY,
    log_text MEDIUMTEXT NOT NULL
) COMMENT = 'mysql exception log';

#����־�Ͳ�ѯ��־pt���߶�Ӧ�ı�����
drop TABLE slow_general_log_table_config;
CREATE TABLE slow_general_log_table_config
(
    host_id MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY ,
    slow_log_db VARCHAR(50) NOT NULL DEFAULT '',
    slow_log_table VARCHAR(50) NOT NULL DEFAULT '',
    slow_log_table_history VARCHAR(50) NOT NULL DEFAULT '',
    general_log_db VARCHAR(50) NOT NULL DEFAULT '',
    general_log_table VARCHAR(50) NOT NULL DEFAULT '',
    general_log_table_history VARCHAR(50) NOT NULL DEFAULT '',
    is_deleted TINYINT UNSIGNED NOT NULL DEFAULT 0,
    created_time TIMESTAMP NOT NULL DEFAULT now(),
    updated_time TIMESTAMP NOT NULL DEFAULT current_timestamp on UPDATE CURRENT_TIMESTAMP
);

#ִ��sql��־��
CREATE DATABASE backup;
DROP TABLE execute_sql_log;
CREATE TABLE execute_sql_log
(
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    host_id MEDIUMINT UNSIGNED NOT NULL,
    is_backup TINYINT UNSIGNED NOT NULL DEFAULT 0,
    backup_name VARCHAR(50) NOT NULL DEFAULT '',
    `sql` TEXT NOT NULL,
    `comment` VARCHAR(100) NOT NULL DEFAULT '',
    created_time TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE mysql_web_user_info
(
    id MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(20) NOT NULL,
    user_password VARCHAR(100) NOT NULL,
    is_deleted TINYINT UNSIGNED NOT NULL DEFAULT 0,
    created_time TIMESTAMP NOT NULL DEFAULT now(),
    updated_time TIMESTAMP NOT NULL DEFAULT current_timestamp on UPDATE CURRENT_TIMESTAMP
);

insert into mysql_web_user_info (user_name, user_password) values("yangcg", md5("yangcaogui"));

-- -----------------------------------------------------------
-- ����ѯ���ñ�
-- �������ɵ�checksum��bigint��Ҫ��
-- �ֶ��޸ĳ� checksum varchar(25) not null
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `mysql_slow_query_review`;
CREATE TABLE `mysql_slow_query_review` (
  `id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `checksum` VARCHAR(25) NOT NULL,
  `fingerprint` text,
  `sample` mediumtext,
  `first_seen` datetime DEFAULT NULL,
  `last_seen` datetime DEFAULT NULL,
  `reviewed_by` varchar(20) DEFAULT '',
  `reviewed_on` varchar(20) DEFAULT '',
  `reviewed_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `is_reviewed` TINYINT NOT NULL DEFAULT 0,
  `created_time` TIMESTAMP NOT NULL DEFAULT NOW(),
  `modified_time` TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
  `comments` varchar(200) DEFAULT '' COMMENT '��ע',
  UNIQUE KEY (`checksum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `mysql_slow_query_review_history`;
CREATE TABLE `mysql_slow_query_review_history` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `serverid_max` smallint(4) NOT NULL DEFAULT 0,
  `db_max` varchar(30) DEFAULT NULL,
  `user_max` varchar(30) DEFAULT NULL,
  `checksum` VARCHAR(25) NOT NULL,
  `sample` mediumtext NOT NULL,
  `ts_min` datetime NOT NULL,
  `ts_max` datetime NOT NULL,
  `ts_cnt` float DEFAULT NULL,
  `Query_time_sum` float DEFAULT NULL,
  `Query_time_min` float DEFAULT NULL,
  `Query_time_max` float DEFAULT NULL,
  `Query_time_pct_95` float DEFAULT NULL,
  `Query_time_stddev` float DEFAULT NULL,
  `Query_time_median` float DEFAULT NULL,
  `Lock_time_sum` float DEFAULT NULL,
  `Lock_time_min` float DEFAULT NULL,
  `Lock_time_max` float DEFAULT NULL,
  `Lock_time_pct_95` float DEFAULT NULL,
  `Lock_time_stddev` float DEFAULT NULL,
  `Lock_time_median` float DEFAULT NULL,
  `Rows_sent_sum` float DEFAULT NULL,
  `Rows_sent_min` float DEFAULT NULL,
  `Rows_sent_max` float DEFAULT NULL,
  `Rows_sent_pct_95` float DEFAULT NULL,
  `Rows_sent_stddev` float DEFAULT NULL,
  `Rows_sent_median` float DEFAULT NULL,
  `Rows_examined_sum` float DEFAULT NULL,
  `Rows_examined_min` float DEFAULT NULL,
  `Rows_examined_max` float DEFAULT NULL,
  `Rows_examined_pct_95` float DEFAULT NULL,
  `Rows_examined_stddev` float DEFAULT NULL,
  `Rows_examined_median` float DEFAULT NULL,
  `Rows_affected_sum` float DEFAULT NULL,
  `Rows_affected_min` float DEFAULT NULL,
  `Rows_affected_max` float DEFAULT NULL,
  `Rows_affected_pct_95` float DEFAULT NULL,
  `Rows_affected_stddev` float DEFAULT NULL,
  `Rows_affected_median` float DEFAULT NULL,
  `Rows_read_sum` float DEFAULT NULL,
  `Rows_read_min` float DEFAULT NULL,
  `Rows_read_max` float DEFAULT NULL,
  `Rows_read_pct_95` float DEFAULT NULL,
  `Rows_read_stddev` float DEFAULT NULL,
  `Rows_read_median` float DEFAULT NULL,
  `Merge_passes_sum` float DEFAULT NULL,
  `Merge_passes_min` float DEFAULT NULL,
  `Merge_passes_max` float DEFAULT NULL,
  `Merge_passes_pct_95` float DEFAULT NULL,
  `Merge_passes_stddev` float DEFAULT NULL,
  `Merge_passes_median` float DEFAULT NULL,
  `InnoDB_IO_r_ops_min` float DEFAULT NULL,
  `InnoDB_IO_r_ops_max` float DEFAULT NULL,
  `InnoDB_IO_r_ops_pct_95` float DEFAULT NULL,
  `InnoDB_IO_r_ops_stddev` float DEFAULT NULL,
  `InnoDB_IO_r_ops_median` float DEFAULT NULL,
  `InnoDB_IO_r_bytes_min` float DEFAULT NULL,
  `InnoDB_IO_r_bytes_max` float DEFAULT NULL,
  `InnoDB_IO_r_bytes_pct_95` float DEFAULT NULL,
  `InnoDB_IO_r_bytes_stddev` float DEFAULT NULL,
  `InnoDB_IO_r_bytes_median` float DEFAULT NULL,
  `InnoDB_IO_r_wait_min` float DEFAULT NULL,
  `InnoDB_IO_r_wait_max` float DEFAULT NULL,
  `InnoDB_IO_r_wait_pct_95` float DEFAULT NULL,
  `InnoDB_IO_r_wait_stddev` float DEFAULT NULL,
  `InnoDB_IO_r_wait_median` float DEFAULT NULL,
  `InnoDB_rec_lock_wait_min` float DEFAULT NULL,
  `InnoDB_rec_lock_wait_max` float DEFAULT NULL,
  `InnoDB_rec_lock_wait_pct_95` float DEFAULT NULL,
  `InnoDB_rec_lock_wait_stddev` float DEFAULT NULL,
  `InnoDB_rec_lock_wait_median` float DEFAULT NULL,
  `InnoDB_queue_wait_min` float DEFAULT NULL,
  `InnoDB_queue_wait_max` float DEFAULT NULL,
  `InnoDB_queue_wait_pct_95` float DEFAULT NULL,
  `InnoDB_queue_wait_stddev` float DEFAULT NULL,
  `InnoDB_queue_wait_median` float DEFAULT NULL,
  `InnoDB_pages_distinct_min` float DEFAULT NULL,
  `InnoDB_pages_distinct_max` float DEFAULT NULL,
  `InnoDB_pages_distinct_pct_95` float DEFAULT NULL,
  `InnoDB_pages_distinct_stddev` float DEFAULT NULL,
  `InnoDB_pages_distinct_median` float DEFAULT NULL,
  `QC_Hit_cnt` float DEFAULT NULL,
  `QC_Hit_sum` float DEFAULT NULL,
  `Full_scan_cnt` float DEFAULT NULL,
  `Full_scan_sum` float DEFAULT NULL,
  `Full_join_cnt` float DEFAULT NULL,
  `Full_join_sum` float DEFAULT NULL,
  `Tmp_table_cnt` float DEFAULT NULL,
  `Tmp_table_sum` float DEFAULT NULL,
  `Tmp_table_on_disk_cnt` float DEFAULT NULL,
  `Tmp_table_on_disk_sum` float DEFAULT NULL,
  `Filesort_cnt` float DEFAULT NULL,
  `Filesort_sum` float DEFAULT NULL,
  `Filesort_on_disk_cnt` float DEFAULT NULL,
  `Filesort_on_disk_sum` float DEFAULT NULL,
  `created_time` TIMESTAMP NOT NULL DEFAULT NOW(),
  `modified_time` TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
  KEY `idx_checksum` (`checksum`, serverid_max)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- -------------------------------------------------------------------

/*
#ͳ������ѯƵ����־��
drop table mysql_slow_query_log;
CREATE TABLE mysql_slow_query_log
(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  checksum BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '����ѯsql��checksumֵ',
  created_time TIMESTAMP NOT NULL DEFAULT NOW() COMMENT '����ѯ���ֵ�ʱ��'
) ENGINE=Innodb DEFAULT  CHARSET=utf8 COMMENT '����ѯ��־��';

#insert������
DROP TRIGGER IF EXISTS insert_trigger;
delimiter $$
CREATE TRIGGER insert_trigger AFTER INSERT ON mysql_web.mysql_slow_query_review FOR EACH ROW
BEGIN
     insert into mysql_web.mysql_slow_query_log(checksum, created_time) values(new.checksum, new.first_seen);
END $$
delimiter ;

#update������
DROP TRIGGER IF EXISTS update_trigger;
delimiter $$
CREATE TRIGGER update_trigger AFTER UPDATE ON mysql_web.mysql_slow_query_review FOR EACH ROW
BEGIN
     insert into mysql_web.mysql_slow_query_log(checksum, created_time) values(new.checksum, new.last_seen);
END $$
delimiter ;
*/

CREATE TABLE backup_task
(
  task_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '����',
  host_id MEDIUMINT UNSIGNED NOT NULL COMMENT 'Ҫ���ݵĻ���id',
  name VARCHAR(30) NOT NULL DEFAULT '' COMMENT '��������',
  tool TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '���ݷ�ʽ��Ҳ���ǲ���ʲô���߽��б���',
  mode TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '����ģʽ��ȫ����������',
  cycle VARCHAR(30) NOT NULL DEFAULT '' COMMENT '�������ڣ�ֻ��������ʱ���������',
  time TIME NOT NULL COMMENT '����ʱ�䣬ÿ��ʲôʱ��ʼ���ݣ������ǰ��죬�������賿�Ժ�',
  save_days MEDIUMINT UNSIGNED NOT NULL COMMENT '�����ļ���������',
  compress TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ʱ��ѹ����Ĭ�ϲ�ѹ��',
  storage_host_id TINYINT UNSIGNED NOT NULL COMMENT '�����ļ��洢����',
  directory VARCHAR(100) NOT NULL DEFAULT '' COMMENT '����Ŀ¼������Ҫ',
  is_deleted TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '�Ƿ�ɾ����Ҳ����˵�Ƿ񱻽���',
  created_time TIMESTAMP NOT NULL DEFAULT now() COMMENT '',
  updated_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''
) ENGINE=innodb CHARSET=utf8 COMMENT='���ݼƻ���';

CREATE TABLE backup_log
(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '����',
  task_id INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��������id',
  file VARCHAR(100) NOT NULL DEFAULT '' COMMENT '�����ļ����ƻ���Ŀ¼����',
  size BIGINT UNSIGNED NOT NULL COMMENT '�����ļ�����Ŀ¼�ܴ�С',
  start_datetime TIMESTAMP NOT NULL COMMENT '���ݿ�ʼʱ��',
  stop_datetime TIMESTAMP NOT NULL COMMENT '���ݽ���ʱ��',
  status TINYINT NOT NULL COMMENT '����״̬�����ݽ����У����ݳɹ�������ʧ��',
  result TEXT COMMENT '�洢���ݽ��������Ҫ�洢xtrabackup����־',
  created_time TIMESTAMP NOT NULL DEFAULT now() COMMENT '���ݲ���ʱ��'
) ENGINE=innodb CHARSET=utf8 COMMENT='������־��';

INSERT  INTO  backup_log (id, task_id, file, size, start_datetime, stop_datetime, status, result, created_time);


CREATE TABLE table_size_log
(
  id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  host_id MEDIUMINT UNSIGNED NOT NULL COMMENT '����id',
  db_name VARCHAR(50) NOT NULL DEFAULT '' COMMENT '���ݿ�����',
  table_name VARCHAR(50) NOT NULL DEFAULT '' COMMENT '������',
  data_size BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '���ݴ�С',
  index_size BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '������С',
  total_size BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '�ܴ�С=����+����',
  rows INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '����',
  auto_increment BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '������ID',
  file_size BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '�ļ���С-ibd�ļ�',
  free_size BIGINT NOT NULL DEFAULT 0 COMMENT '������Ƭ��С',
  increase_size INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '������������������Ĵ�С=total_szie-total_size(�����)',
  `date` DATE NOT NULL COMMENT '������������',
  created_time TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '�и���ʱ��',
  UNIQUE KEY host_id_date(`host_id`, `date`)
) ENGINE=innodb CHARSET=utf8 COMMENT='���С��־��';

CREATE TABLE host_all_table_size_log
(
  id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  host_id MEDIUMINT UNSIGNED NOT NULL COMMENT '����id',
  data_size BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '�����ݴ�С',
  index_size BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '��������С',
  total_size BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '�ܴ�С=������+������',
  rows BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '������',
  file_size BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '���ļ���С-ibd�ļ�',
  free_size BIGINT NOT NULL DEFAULT 0 COMMENT '��������Ƭ��С',
  increase_size BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '������������������Ĵ�С=total_szie-total_size(�����)',
  `date` DATE NOT NULL COMMENT '������������',
  created_time TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '�и���ʱ��',
  UNIQUE KEY host_id_date(`host_id`, `date`)
) ENGINE=innodb CHARSET=utf8 COMMENT='mysqlʵ���������ܴ�С';