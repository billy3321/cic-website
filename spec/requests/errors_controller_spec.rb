require "rails_helper"

describe "404 page" do
  it "is customized" do
    # Haven't been able to get the "show instead of exceptions" thing working in tests, but this at least makes sure the page can render correctly.
    visit "/404"
    expect(page.status_code).to eq 404
    expect(page).to have_content("你想找的頁面不存在或是已經被移除了")
  end

  it "json work" do
    visit "/404.json"
    expect(page.status_code).to eq 404
  end
end

describe "422 page" do
  it "is customized" do
    # Haven't been able to get the "show instead of exceptions" thing working in tests, but this at least makes sure the page can render correctly.
    visit "/422"
    expect(page.status_code).to eq 422
    expect(page).to have_content("請確認你是否有操作這個動作的權限")
  end

  it "json work" do
    visit "/422.json"
    expect(page.status_code).to eq 422
  end
end

describe "500 page" do
  it "is customized" do
    # Haven't been able to get the "show instead of exceptions" thing working in tests, but this at least makes sure the page can render correctly.
    visit "/500"
    expect(page.status_code).to eq 500
    expect(page).to have_content("網站目前有些難以解釋的問題")
  end

  it "json work" do
    visit "/500.json"
    expect(page.status_code).to eq 500
  end
end