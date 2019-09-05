function selectFavoriteCuisine() {
  const cuisineDivs = document.querySelectorAll(".cuisine-card");

  cuisineDivs.forEach(function(element) {
    element.addEventListener("click", function(){
      document.querySelector("#user_cuisine_ids_" + element.dataset.id).click()
    });
  });
}

export {selectFavoriteCuisine}
