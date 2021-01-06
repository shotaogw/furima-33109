const pay = () => {
  Payjp.setPublicKey(process.env.PAYJP_PUBLIC_KEY);
  const form = document.getElementById("charge-form");
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const formContent = document.getElementById("charge-form");
    const formData = new FormData(formContent); //FormDataオブジェクト生成
    const card = {
      number: formData.get("purchase_detail[number]"),
      exp_month: formData.get("purchase_detail[exp_month]"),
      exp_year: `20${formData.get("purchase_detail[exp_year]")}`,
      cvc: formData.get("purchase_detail[cvc]"),
    };
    Payjp.createToken(card, (status, response) => {
      if (status == 200) {
        const token = response.id;
        const renderDom = document.getElementById("charge-form");
        const tokenObject = `<input value=${token} name="token" type="hidden">`;
        renderDom.insertAdjacentHTML("beforeend", tokenObject);
      }
      document.getElementById("card-number").removeAttribute("name");
      document.getElementById("card-exp-month").removeAttribute("name");
      document.getElementById("card-exp-year").removeAttribute("name");
      document.getElementById("card-cvc").removeAttribute("name");
      document.getElementById("charge-form").submit();
    });
  });
};

window.addEventListener("load", pay);