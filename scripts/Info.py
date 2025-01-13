import psutil
from getmac import get_mac_address

def getInfo():
    data = {}
    ram =  psutil.virtual_memory()
    data['mac']= get_mac_address()
    data['user'] = psutil.users()[0].name
    data['cpu']={
        'freq': psutil.cpu_freq().current,
        'persent':psutil.cpu_percent(),
    }

    data['ram']={
        'persent': ram.percent,
        'total': ram.total,
        'available': ram.available,
    }

    data['disk_data']={}
    for disk in psutil.disk_partitions():
        diskInfo=psutil.disk_usage(disk.device)
        infos={
        'percentage_used': diskInfo.percent,
        'total': diskInfo.total,
        'free': diskInfo.free
        }
        data['disk_data'][disk.device] = infos
    return data
    
