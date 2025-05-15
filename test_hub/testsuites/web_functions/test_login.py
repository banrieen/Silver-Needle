# Copyright (c) banrieen.
# slug:  autotest
# title: 测试用例
# update: 2025-05-14
# authors: banrieen
# tags: v0.1


import pytest
from playwright.sync_api import expect
import re


# 测试数据配置（可根据实际需求参数化）
BASE_URL = "http://192.168.12.26:5008/#/login"
TEST_ACCOUNT = "HY"
TEST_PASSWORD = "123"
SUCCESS_LOGIN_INDICATOR = "首页"  # 登录成功后的页面标题标识
VALID_ACCOUNT = "admin"
VALID_PASSWORD = "Test@1234"


@pytest.fixture(scope="function")
def login_page(page):
    page.goto(BASE_URL)
    return {
        "username_input": page.get_by_placeholder("账号"),
        "password_input": page.get_by_placeholder("密码"),
        "login_button": page.get_by_role("button", name="登录"),
        "page": page
    }


def test_ui_elements_visibility(login_page):
    """验证登录表单关键元素可见性"""
    expect(login_page["username_input"]).to_be_visible()
    expect(login_page["password_input"]).to_be_visible()
    expect(login_page["login_button"]).to_be_visible()
    expect(login_page["page"].get_by_text("欢迎登录", exact=True)).to_be_visible()


def test_successful_login(login_page):
    """验证有效凭证登录流程"""
    # 输入有效凭证
    login_page["username_input"].fill(TEST_ACCOUNT)
    login_page["password_input"].fill(TEST_PASSWORD)
    # 点击登录并验证跳转
    with login_page["page"].expect_navigation():
        login_page["login_button"].click()

    expect(login_page["page"]).to_have_url(re.compile(r".*/dashboard"))


def test_empty_credentials_submission(login_page):
    """验证空凭证提交错误提示"""
    login_page["login_button"].click()
    
    # 验证账号错误提示
    expect(login_page["page"].get_by_text("请输入账号")).to_be_visible()

    # 验证密码错误提示
    expect(login_page["page"].get_by_text("请输入密码")).to_be_visible()
    expect(login_page["page"].get_by_text("请输入密码")).to_have_css("color", "rgb(245, 108, 108)")


def test_invalid_credentials(login_page):
    """验证无效凭证错误提示"""
    # 输入无效测试数据
    login_page["username_input"].fill("wrong_user")
    login_page["password_input"].fill("wrong_pass")
    login_page["login_button"].click()
    
    # 验证错误提示
    error_message = login_page["page"].get_by_text("用户名不存在或密码错误")
    expect(error_message).to_be_visible()
    expect(error_message).to_have_css("color", "rgb(245, 108, 108)")


def test_input_validation(login_page):
    """验证输入框的交互行为"""
    # 测试账号输入
    login_page["username_input"].fill("test@user")
    expect(login_page["username_input"]).to_have_value("test@user")  # 验证自动trim
    
    # 测试密码显示
    expect(login_page["password_input"]).to_have_attribute("type", "password")
    
    # 测试按钮状态
    expect(login_page["login_button"]).to_be_enabled()