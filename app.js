const mobileInput = document.getElementById("mobile");
const amountInput = document.getElementById("amount");
const noteInput = document.getElementById("note");
const result = document.getElementById("result");
const historyList = document.getElementById("history");

function showHistory(message) {
  const empty = historyList.querySelector(".empty");
  if (empty) empty.remove();
  const item = document.createElement("li");
  item.textContent = message;
  historyList.prepend(item);
}

document.getElementById("payButton").addEventListener("click", () => {
  const mobile = mobileInput.value.trim();
  const amount = Number(amountInput.value);

  if (!/^\d{10}$/.test(mobile)) {
    result.hidden = false;
    result.textContent = "డెమో కోసం 10 అంకెల కల్పిత మొబైల్ నంబర్ నమోదు చేయండి.";
    return;
  }
  if (!Number.isFinite(amount) || amount < 1 || amount > 10000) {
    result.hidden = false;
    result.textContent = "₹1 నుంచి ₹10,000 మధ్య డెమో మొత్తాన్ని నమోదు చేయండి.";
    return;
  }

  result.hidden = false;
  result.textContent = "డెమో మాత్రమే: ఎలాంటి చెల్లింపు జరగలేదు. డబ్బు బదిలీ కాలేదు.";
  const masked = "XXXXXX" + mobile.slice(-4);
  const note = noteInput.value.trim();
  showHistory(`డెమో ప్రయత్నం • ₹${amount.toFixed(2)} • ${masked}${note ? " • " + note : ""} • చెల్లింపు జరగలేదు`);
});

document.getElementById("clearButton").addEventListener("click", () => {
  historyList.innerHTML = '<li class="empty">ఇంకా డెమో ప్రయత్నాలు లేవు.</li>';
  result.hidden = true;
  result.textContent = "";
});
