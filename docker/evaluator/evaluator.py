import requests

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

check()