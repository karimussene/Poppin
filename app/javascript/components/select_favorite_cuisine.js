function selectFavoriteCuisine() {
  const cuisineDivs = document.querySelectorAll(".cuisine-card");

  cuisineDivs.forEach(function(element) {
    element.addEventListener("click", function(){
      document.querySelector("#user_cuisine_ids_" + element.dataset.id).click()
    });
  });
}

const selectedTick = () => {
  const cards = document.getElementsByClassName("hover-darker-cuisine-card");

  for (let i = 0; i < cards.length; i++) {
    cards[i].addEventListener('mouseleave', (event) => {
      cards[i].classList.remove('just-selected-card');
    });

    cards[i].addEventListener('click', (event) => {
      const cardToSelect = cards[i].getElementsByClassName('to-select')[0];
      cards[i].classList.toggle('selected-card');
      cards[i].classList.add('just-selected-card');

      if (cardToSelect){
        cardToSelect.classList.toggle('small-cuisine-card-select-sign');
      }
    });
  };
}

export { selectFavoriteCuisine, selectedTick }
