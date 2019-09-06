function selectFavoriteCuisine() {
  const cuisineDivs = document.querySelectorAll(".cuisine-card");

  cuisineDivs.forEach(function(element) {
    element.addEventListener("click", function(){
      document.querySelector("#user_cuisine_ids_" + element.dataset.id).click()
    });
  });
}

const selectedTick = () => {
  let cardImages = document.getElementsByClassName("small-cuisine-card-image");

  for (let i = 0; i < cardImages.length; i++) {
    //console.log(cardImages[i]);

    cardImages[i].addEventListener("click", (e) => {
      let cardToSelect = e.currentTarget.nextElementSibling;
      console.log("image clicked, nearest div: ", cardToSelect);
      if(cardToSelect){
        cardToSelect.classList.toggle("small-cuisine-card-select-sign");
      }
    });
  };
}

export { selectFavoriteCuisine, selectedTick }
