import requests
import time

def check():

    try:
        resp = requests.get(
            "http://app:5000/health",
            timeout=5
        )

        if resp.status_code == 200:
            print("PASS")
        else:
            print("FAIL")

    except Exception:
        print("FAIL")

while True:
    check()
    time.sleep(60)