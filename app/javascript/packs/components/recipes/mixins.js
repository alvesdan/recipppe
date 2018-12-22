export default {
  methods: {
    buildFragmentCreateUrl: function(recipe) {
      return "/recipes/" + recipe.id + "/fragments.json"
    },
    buildFragmentUpdateUrl: function(fragment) {
      return "/recipes/" + fragment.recipe_id + "/fragments/" + fragment.id + ".json"
    },
    buildFragmentDeleteUrl: function(fragment) {
      return "/recipes/" + fragment.recipe_id + "/fragments/" + fragment.id + ".json"
    },
    buildFragmentsPositionsUpdateUrl: function(recipe) {
      return "/recipes/" + recipe.id + "/update_fragments_positions.json"
    },
    placeCareAtEndOf: function(el) {
      el.focus();
      if (typeof window.getSelection != "undefined"
              && typeof document.createRange != "undefined") {
          var range = document.createRange();
          range.selectNodeContents(el);
          range.collapse(false);
          var sel = window.getSelection();
          sel.removeAllRanges();
          sel.addRange(range);
      } else if (typeof document.body.createTextRange != "undefined") {
          var textRange = document.body.createTextRange();
          textRange.moveToElementText(el);
          textRange.collapse(false);
          textRange.select();
      }
    }
  }
};
