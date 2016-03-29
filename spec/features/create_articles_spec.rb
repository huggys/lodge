require 'rails_helper'

feature "CreateArticles", :type => :feature do
  let(:user) { FactoryGirl.create(:user) }
  background do
    login_as user, scope: :user
  end

  scenario "create new article" do

    tags = %w(tag0 tag1 tag2 tag3 tag4 tag5 tag6 tag7 tag8 tag9)
    new_article_title = "new article"

    expect {
      visit new_article_path
      fill_in I18n.t("activerecord.attributes.article.title"), with: new_article_title
      fill_in_autocomplete("#article_tag_list", tags.join(","))
      fill_in I18n.t("activerecord.attributes.article.body"), with: "body"
      find_button(I18n.t("helpers.submit.create")).click
    }.to change{ Article.count }.by(1)

    expect(page).to have_content(new_article_title)
    tags.each do |tag|
      expect(page).to have_link(tag, href: tagged_articles_path(tag: tag))
    end
    expect(page).to have_content("body")

    find_link(I18n.t("common.user_article_list_title")).trigger('click')
    expect(page).to have_link(new_article_title)

    find_link(I18n.t("common.recent_article_list_title")).trigger('click')
    expect(page).to have_link(new_article_title)
  end
end
