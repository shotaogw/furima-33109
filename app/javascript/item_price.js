window.addEventListener('load', function() {
  const priceInput = document.getElementById("item-price");
  priceInput.addEventListener('input', () => {
    const inputValue = Math.floor(priceInput.value);
    const priceTax = document.getElementById("add-tax-price");
    const priceProfit = document.getElementById("profit");
    priceTax.innerHTML = Math.floor(inputValue * 0.1);
    priceProfit.innerHTML = Math.floor(inputValue - priceTax.innerHTML);
  });
});