import threading, time

#ͼ���ռ����ܱ�
#��ÿ���ֻ��������ݽ��л��ܣ���֣�ʱ���������

class ChartThread(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.setDaemon(True)

    def run(self):
        while(True):
            time.sleep(5)
            self.collect_data_for_day()
            self.collect_data_for_hour()
            self.collect_data_for_minute()

    def collect_data_for_day(self):
        pass

    def collect_data_for_hour(self):
        pass

    def collect_data_for_minute(self):
        pass

