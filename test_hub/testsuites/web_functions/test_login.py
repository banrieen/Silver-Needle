import pytest
from playwright.sync_api import Page, expect
from axe_core_playwright import AxeBuilder  # 需要安装axe-core-playwright

# 测试配置
TEST_CREDENTIALS = {
    "valid": {"username": "test_user", "password": "ValidPass123!"},
    "invalid": {"username": "test_user", "password": "wrong_pass"}
}

def test_login_functionality_and_accessibility(page: Page):
    # 基础导航
    page.goto("http://your-login-page-url.com")  # 替换实际URL
    expect(page).to_have_title("远程实时监控平台 (RTM Platform)")

    # 元素存在性检查
    expect(page.locator("text=欢迎登录")).to_be_visible()
    expect(page.locator("text=Copyright 埃克斯工业（广东）有限公司")).to_be_visible()

    # 功能测试 - 空字段提交
    page.locator("text=登录").click()
    expect(page.locator("text=账号不能为空")).to_be_visible()  # 替换实际错误提示选择器

    # 功能测试 - 无效凭证
    page.locator("[placeholder='请输入账号']").fill(TEST_CREDENTIALS["invalid"]["username"])
    page.locator("[type='password']").fill(TEST_CREDENTIALS["invalid"]["password"])
    page.locator("text=登录").click()
    expect(page.locator("text=账号或密码错误")).to_be_visible()  # 替换实际错误提示选择器

    # 功能测试 - 成功登录（需要配置有效凭证）
    # page.locator("[placeholder='请输入账号']").fill(TEST_CREDENTIALS["valid"]["username"])
    # page.locator("[type='password']").fill(TEST_CREDENTIALS["valid"]["password"])
    # page.locator("text=登录").click()
    # expect(page.url).to_contain("/dashboard")  # 替换实际成功跳转路径

    # 可访问性测试（使用axe-core）
    axe = AxeBuilder(page)
    results = axe.analyze()

    # 验证无严重可访问性问题
    violations = [v for v in results["violations"] if v["impact"] in ["critical", "serious"]]
    assert not violations, f"发现可访问性问题：{violations}"

    # 自定义可访问性检查
    custom_checks = [
        # 验证表单标签关联
        lambda: expect(page.locator("[placeholder='请输入账号'])).to_have_attribute(
            "aria-label", "账号"
        ),
        # 验证颜色对比度（假设按钮背景为#007bff，文字为白色）
        lambda: expect(page.locator("text=登录")).to_have_css(
            "background-color", "rgb(0, 123, 255)"
        ),
        # 验证键盘可访问性
        lambda: page.locator("text=登录").press("Enter"),
        lambda: expect(page.locator("text=账号不能为空")).to_be_visible()
    ]

    for check in custom_checks:
        check()

    # 可访问性报告生成（可选）
    with open("accessibility-report.json", "w") as f:
        f.write(str(results))