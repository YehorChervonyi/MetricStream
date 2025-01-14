import psutil
from getmac import get_mac_address
import socket

def get_ip_address():
    # Get the network interfaces using psutil
    interfaces = psutil.net_if_addrs()
    
    # Iterate through the interfaces to find the IP address
    for interface, addresses in interfaces.items():
        for address in addresses:
            # Check if the address family is AF_INET (IPv4)
            if address.family == socket.AF_INET:
                # Return the IP address
                return address.address
    return None


def getInfo():
    data = {}
    ram =  psutil.virtual_memory()
    data['user'] = psutil.users()[0].name
    data['mac']= get_mac_address()
    data['ip']= get_ip_address()
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
    
