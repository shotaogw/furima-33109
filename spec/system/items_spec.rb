require 'rails_helper'

RSpec.describe '商品出品', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item)
  end
  context '商品出品ができるとき' do
    it 'ログインユーザーは商品出品できる' do
      #ログインする
      sign_in(@user)
      #商品出品ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('出品する')
      expect(page).to have_content('新規投稿商品')
      #出品ページに移動する
      visit new_item_path
      #フォームに正しい情報を入力する
      attach_file('item[image]', 'public/test_image.png', make_visible: true)
      fill_in 'item-name', with: @item.title
      fill_in 'item-info', with: @item.info
      select 'レディース', from: 'item[category_id]'
      select '未使用に近い', from: 'item[status_id]'
      select '送料込み(出品者負担)', from: 'item[shipping_fee_id]'
      select '東京都', from: 'item[prefecture_id]'
      select '1〜2日で発送', from: 'item[delivery_day_id]'
      fill_in 'item-price', with: @item.price
      #出品するボタンを押すとItemモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Item.count }.by(1)
      #トップページへ遷移する
      visit root_path
      #トップページに先ほど出品した商品が存在することを確認する(画像)
      expect(page).to have_selector("img[src$='test_image.png']")
      #トップページに先ほど出品した商品が存在することを確認する(商品名)
      expect(page).to have_content(@item.title)
      #トップページに先ほど出品した商品が存在することを確認する(販売価格)
      expect(page).to have_content(@item.price)
      #トップページに先ほど出品した商品が存在することを確認する(配送料の負担)
      expect(page).to have_content('送料込み(出品者負担)')
    end
  end
  context '商品出品ができないとき' do
    it '非ログインユーザーは商品出品できない' do
      #トップページへ遷移する
      visit root_path
      #商品出品ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('出品する')
      expect(page).to have_content('新規投稿商品')
      #ログインページへ遷移する
      visit new_user_session_path
    end
    it 'ログインユーザーでも正しく情報を入力しないと商品出品できない' do
      #ログインする
      sign_in(@user)
      #商品出品ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('出品する')
      expect(page).to have_content('新規投稿商品')
      #出品ページに移動する
      visit new_item_path
      #フォームに正しくない情報を入力する
      attach_file(nil, 'public/test_image.png', make_visible: true)
      fill_in 'item-name', with: ''
      fill_in 'item-info', with: ''
      select '--', from: 'item[category_id]'
      select '--', from: 'item[status_id]'
      select '--', from: 'item[shipping_fee_id]'
      select '--', from: 'item[prefecture_id]'
      select '--', from: 'item[delivery_day_id]'
      fill_in 'item-price', with: ''
      #出品するボタンを押してもItemモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Item.count }.by(0)
      #商品出品ページへ戻されることを確認する
      expect(current_path).to eq "/items"
    end
  end
end

RSpec.describe '商品詳細', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @user = FactoryBot.create(:user)
  end
  it 'ログイン状態の出品者ユーザーは商品詳細ページに編集と削除のボタンが表示される' do
    #ログインする
    sign_in(@item.user)
    #商品詳細ページへ遷移する
    move_to_show(@item)
    #詳細ページに編集ボタンが表示されることを確認する
    expect(page).to have_link '商品の編集', href: "/items/#{@item.id}/edit"
    #詳細ページに削除ボタンが表示されることを確認する
    expect(page).to have_link '削除', href: "/items/#{@item.id}"
    #詳細ページに購入ボタンが表示されないことを確認する
    expect(page).to have_no_link '購入画面に進む', href: "/items/#{@item.id}/purchases"
  end
  it 'ログイン状態の出品者以外のユーザーは商品詳細ページに購入のボタンが表示される' do
    #ログインする
    sign_in(@user)
    #商品詳細ページへ遷移する
    move_to_show(@item)
    #詳細ページに購入ボタンが表示されることを確認する
    expect(page).to have_link '購入画面に進む', href: "/items/#{@item.id}/purchases"
    #詳細ページに編集ボタンが表示されないことを確認する
    expect(page).to have_no_link '商品の編集', href: "/items/#{@item.id}/edit"
    #詳細ページに削除ボタンが表示されないことを確認する
    expect(page).to have_no_link '削除', href: "/items/#{@item.id}"
  end
  it '非ログインユーザーの商品詳細ページには編集、削除、購入のボタンが表示されない' do
    #トップページに移動する
    visit root_path
    #商品詳細ページへ遷移する
    move_to_show(@item)
    #詳細ページに編集ボタンが表示されないことを確認する
    expect(page).to have_no_link '商品の編集', href: "/items/#{@item.id}/edit"
    #詳細ページに削除ボタンが表示されないことを確認する
    expect(page).to have_no_link '削除', href: "/items/#{@item.id}"
    #詳細ページに購入ボタンが表示されないことを確認する
    expect(page).to have_no_link '購入画面に進む', href: "/items/#{@item.id}/purchases"
  end
end

RSpec.describe '商品編集', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @edit_item = FactoryBot.build(:item)
    @user = FactoryBot.create(:user)
  end
  context '商品編集ができるとき' do
    it 'ログイン状態の出品者ユーザーは商品を編集できる' do
    #ログインする
    sign_in(@item.user)
    #商品詳細ページへ遷移する
    move_to_show(@item)
    #詳細ページに編集ボタンが表示されることを確認する
    expect(page).to have_link '商品の編集', href: "/items/#{@item.id}/edit"
    #編集ページへ遷移する
    visit edit_item_path(@item.id)
    #すでに投稿済みの内容がフォームに入っていることを確認する
    expect(
      find('#item-name').value
    ).to eq @item.title
    expect(
      find('#item-info').value
    ).to eq @item.info
    expect(
      find('#item-category').value
    ).to eq "#{@item.category_id}"
    expect(
      find('#item-sales-status').value
    ).to eq "#{@item.status_id}"
    expect(
      find('#item-shipping-fee-status').value
    ).to eq "#{@item.shipping_fee_id}"
    expect(
      find('#item-prefecture').value
    ).to eq "#{@item.prefecture_id}"
    expect(
      find('#item-scheduled-delivery').value
    ).to eq "#{@item.delivery_day_id}"
    expect(
      find('#item-price').value
    ).to eq "#{@item.price}"
    #投稿内容を編集する
    attach_file('item[image]', 'public/test_image.png', make_visible: true)
    fill_in 'item-name', with: @edit_item.title
    fill_in 'item-info', with: @edit_item.info
    select @edit_item.category.name, from: 'item[category_id]'
    select @edit_item.status.name, from: 'item[status_id]'
    select @edit_item.shipping_fee.name, from: 'item[shipping_fee_id]'
    select @edit_item.prefecture.name, from: 'item[prefecture_id]'
    select @edit_item.delivery_day.name, from: 'item[delivery_day_id]'
    fill_in 'item-price', with: @edit_item.price
    #変更するボタンを押してもItemモデルのカウントは上がらないことを確認する
    expect{
      find('input[name="commit"]').click
    }.to change{ Item.count }.by(0)
    #詳細ページに先ほど変更した内容が反映されていることを確認する（画像）
    expect(page).to have_selector("img[src$='test_image.png']")
    #詳細ページに先ほど変更した内容が反映されていることを確認する（商品名）
    expect(page).to have_content(@edit_item.title)
    #詳細ページに先ほど変更した内容が反映されていることを確認する（商品の説明）
    expect(page).to have_content(@edit_item.info)
    #詳細ページに先ほど変更した内容が反映されていることを確認する（カテゴリー）
    expect(page).to have_content(@edit_item.category.name)
    #詳細ページに先ほど変更した内容が反映されていることを確認する（商品の状態）
    expect(page).to have_content(@edit_item.status.name)
    #詳細ページに先ほど変更した内容が反映されていることを確認する（配送料の負担）
    expect(page).to have_content(@edit_item.shipping_fee.name)
    #詳細ページに先ほど変更した内容が反映されていることを確認する（発送元の地域）
    expect(page).to have_content(@edit_item.prefecture.name)
    #詳細ページに先ほど変更した内容が反映されていることを確認する（発送までの日数）
    expect(page).to have_content(@edit_item.delivery_day.name)
    #詳細ページに先ほど変更した内容が反映されていることを確認する（販売価格）
    expect(page).to have_content(@edit_item.price)
    #トップページへ遷移する
    visit root_path
    #トップページに先ほど変更した内容が反映されていることを確認する（画像）
    expect(page).to have_selector("img[src$='test_image.png']")
    #トップページに先ほど変更した内容が反映されていることを確認する（商品名）
    expect(page).to have_content(@edit_item.title)
    #トップページに先ほど変更した内容が反映されていることを確認する（販売価格）
    expect(page).to have_content(@edit_item.price)
    #トップページに先ほど変更した内容が反映されていることを確認する（配送料の負担）
    expect(page).to have_content(@edit_item.shipping_fee.name)
    end
  end
  context '商品編集ができないとき' do
    it 'ログイン状態の出品者以外のユーザーは商品の編集ページに移動できない' do
    #ログインする
    sign_in(@user)
    #商品詳細ページへ遷移する
    move_to_show(@item)
    #詳細ページに編集ボタンが表示されないことを確認する
    expect(page).to have_no_link '商品の編集', href: "/items/#{@item.id}/edit"
    end
    it '非ログインユーザーは商品の編集ページに移動できない' do
    #トップページに移動する
    visit root_path
    #商品詳細ページへ遷移する
    move_to_show(@item)
    #詳細ページに編集ボタンが表示されないことを確認する
    expect(page).to have_no_link '商品の編集', href: "/items/#{@item.id}/edit"
    end
  end
end

RSpec.describe '商品削除', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @user = FactoryBot.create(:user)
  end
  context '商品削除ができるとき' do
    it 'ログイン状態の出品者ユーザーは商品を削除できる' do
    #ログインする
    sign_in(@item.user)
    #商品詳細ページへ遷移する
    move_to_show(@item)
    #詳細ページに削除ボタンが表示されることを確認する
    expect(page).to have_link '削除', href: "/items/#{@item.id}"
    #商品を削除するとItemモデルのカウントが1下がることを確認する
    expect{
      find_link('削除', href: "/items/#{@item.id}").click
    }.to change{ Item.count }.by(-1)
    #トップページに先ほど削除した商品が存在しないことを確認する（画像）
    expect(page).to have_no_selector("img[src$='test_image.png']")
    #トップページに先ほど削除した商品が存在しないことを確認する（商品名）
    expect(page).to have_no_content(@item.title)
    #トップページに先ほど削除した商品が存在しないことを確認する（販売価格）
    expect(page).to have_no_content(@item.price)
    #トップページに先ほど削除した商品が存在しないことを確認する（配送料の負担）
    expect(page).to have_no_content(@item.shipping_fee.name)
    end
  end
  context '商品削除ができないとき' do
    it 'ログイン状態の出品者以外のユーザーは商品の削除ができない' do
    #ログインする
    sign_in(@user)
    #商品詳細ページへ遷移する
    move_to_show(@item)
    #詳細ページに削除ボタンが表示されないことを確認する
    expect(page).to have_no_link '削除', href: "/items/#{@item.id}"
    end
    it '非ログインユーザーは商品の削除ができない' do
    #トップページに移動する
    visit root_path
    #商品詳細ページへ遷移する
    move_to_show(@item)
    #詳細ページに削除ボタンが表示されないことを確認する
    expect(page).to have_no_link '削除', href: "/items/#{@item.id}"
    end
  end
end