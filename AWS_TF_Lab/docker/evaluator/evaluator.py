import requests
import time

def check():

    try:
        resp = requests.get(
            "http://app:5000/health",
            timeout=5
        )

        if resp.status_code == 200:
            print("PASS", flush=True)
        else:
            print("FAIL", flush=True)

    except Exception:
        print("FAIL", flush=True)

while True:
    check()
    time.sleep(30)