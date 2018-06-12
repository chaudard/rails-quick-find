document.addEventListener('DOMContentLoaded', () => {

  let selectPriceValue = '-';
  let selectEnseigneValue = '-';

  selectPriceDropDownList = document.getElementById('select_prix');
  selectEnseigneDropDownList = document.getElementById('select_enseigne');

  if (selectPriceDropDownList) {
    selectPriceDropDownList.addEventListener("click", event => {
      selectPriceValue = selectPriceDropDownList.value;
      if (selectEnseigneDropDownList) {
        selectEnseigneValue = selectEnseigneDropDownList.value;
      }
      sort_cards(selectPriceValue, selectEnseigneValue);
    });
  };

  if (selectEnseigneDropDownList) {
    selectEnseigneDropDownList.addEventListener("click", event => {
      selectEnseigneValue = selectEnseigneDropDownList.value;
      if (selectPriceDropDownList) {
        selectPriceValue = selectPriceDropDownList.value;
      }
      sort_cards(selectPriceValue, selectEnseigneValue);
    });
  };
});

// const markersGMapEl = document.querySelectorAll('.gmnoprint');
// console.log(markersGMapEl);
// if (markersGMapEl) {
//   const markersGMapContainerEl = markersGMapEl.first.parentNode;
//   console.log(markersGMapContainerEl);
// }

const cardsPanelEl = document.querySelector('.cards-panel');
const colCards = document.querySelectorAll('.col-card');
let copyOfCardsPanelEl = '';
if (cardsPanelEl) {
  copyOfCardsPanelEl = cardsPanelEl.innerHTML;
}

let prices = [];
let subColCards = [];


function compareCroissant(a,b){
return a-b;
}

function compareDecroissant(a,b){
return b-a;
}

const get_sort_prices = (colCards, selectPriceValue) => {
  const prices = [];
  colCards.forEach((colCard) => {
    const price = parseFloat(colCard.querySelector('.numeric-prix').textContent);
    prices.push(price);
  });
  if (selectPriceValue == 'croissant') {
    prices.sort(compareCroissant);
  } else {
    prices.sort(compareDecroissant);
  }
  return prices;
}

const insert_sort_prices_cards = (prices, colCards) => {
  prices.forEach((price) => {
    colCards.forEach((colCard) => {
      const colCardPrice = parseFloat(colCard.querySelector('.numeric-prix').textContent);
      if (price == colCardPrice) {
        cardsPanelEl.insertAdjacentElement("beforeend", colCard);
      }
    });
  });
}

const get_enseigne_cards = (colCards, selectEnseigneValue) => {
  const  enseigneColCards = [];
  colCards.forEach((colCard) => {
    const provider = colCard.querySelector('.provider').textContent;
    if (provider == selectEnseigneValue) {
      enseigneColCards.push(colCard);
    }
  });
  return enseigneColCards;
}

const sort_cards = (selectPriceValue, selectEnseigneValue) => {
  const cardsPanelEl = document.querySelector('.cards-panel');
  if (cardsPanelEl) {
    if (selectPriceValue == '-' && selectEnseigneValue == '-'){
      // aucun tri
      cardsPanelEl.innerHTML = copyOfCardsPanelEl
    }
    else if (selectPriceValue == '-') {
      cardsPanelEl.innerHTML = '';
      // tri uniquement sur l'enseigne
      subColCards = get_enseigne_cards(colCards, selectEnseigneValue);
      subColCards.forEach((colCard) => {
        cardsPanelEl.insertAdjacentElement("beforeend", colCard);
      });
    }
    else if (selectEnseigneValue == '-') {
      cardsPanelEl.innerHTML = '';
      // tri uniquement sur le prix
      // mettons les prix dans un tableau pour faire le tri
      prices = get_sort_prices(colCards, selectPriceValue);
      insert_sort_prices_cards(prices, colCards);
    }
    else {
      // tri sur l'enseigne et sut le prix
      cardsPanelEl.innerHTML = '';
      subColCards = get_enseigne_cards(colCards, selectEnseigneValue);
      prices = get_sort_prices(subColCards, selectPriceValue);
      insert_sort_prices_cards(prices, subColCards);
    }
  }
}
