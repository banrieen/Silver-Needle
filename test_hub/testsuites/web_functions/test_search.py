from playwright.sync_api import sync_playwright
import json

def bing_search(query: str, max_results: int = 10):
    results = []
    with sync_playwright() as p:
        # Launch browser (Chromium recommended for China)
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36",
            locale="zh-CN"
        )
        page = context.new_page()
        
        # Navigate to Bing China
        page.goto(f"https://cn.bing.com/search?q={query}", timeout=60000)
        
        # Wait for results to load
        page.wait_for_selector(".b_algo", timeout=15000)
        
        # Extract search results
        for item in page.query_selector_all(".b_algo")[:max_results]:
            results.append({
                "title": item.query_selector("h2").text_content().strip(),
                "url": item.query_selector("a").get_attribute("href"),
                "description": item.query_selector(".b_caption p").text_content().strip() if item.query_selector(".b_caption p") else ""
            })
        
        browser.close()
    return results

# Usage
if __name__ == "__main__":
    results = bing_search("人工智能最新发展")
    print(json.dumps(results, ensure_ascii=False, indent=2))