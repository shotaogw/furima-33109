module MoveToShowSupport
  def move_to_show(item)
    expect(page).to have_selector("img[src$='test_image.png']")
    expect(page).to have_content(item.title)
    expect(page).to have_content(item.price)
    expect(page).to have_content(item.shipping_fee_id)
    visit item_path(item.id)
  end
end