#
#


import argparse
import requests
import random

class StealthFetcher:
    def __init__(self, timeout=10):
        self.timeout = timeout
        self.headers_list = [
            {
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                              "(KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
                "Accept": "*/*",
                "Accept-Language": "en-US,en;q=0.5",
                "Connection": "keep-alive"
            },
            {
                "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0",
                "Accept": "*/*",
                "Accept-Language": "en-US,en;q=0.9",
                "Connection": "keep-alive"
            },
            {
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                              "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15",
                "Accept": "*/*",
                "Accept-Language": "en-US,en;q=0.8",
                "Connection": "keep-alive"
            }
        ]

    def random_headers(self):
        return random.choice(self.headers_list)

    def fetch(self, url):
        try:
            headers = self.random_headers()
            response = requests.get(url, timeout=self.timeout, headers=headers)
            response.raise_for_status()
            print(response.text)
        except requests.exceptions.RequestException as e:
            print(f"[ERROR] {url} -> {e}")

    def fetch_from_file(self, filepath):
        try:
            with open(filepath, "r") as file:
                urls = [u.strip() for u in file.readlines() if u.strip()]

            for url in urls:
                self.fetch(url)

        except FileNotFoundError:
            pass


def main():
    parser = argparse.ArgumentParser(description="Advanced Stealth Web Content Fetcher")
    parser.add_argument("-u", "--url", help="Single URL to fetch")
    parser.add_argument("-f", "--file", help="File containing list of URLs")

    args = parser.parse_args()

    fetcher = StealthFetcher()

    if args.url:
        fetcher.fetch(args.url)
    elif args.file:
        fetcher.fetch_from_file(args.file)
    else:
        print("Please use -u for URL or -f for file.")
        exit()


if __name__ == "__main__":
    main()

