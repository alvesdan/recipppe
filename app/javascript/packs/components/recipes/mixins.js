export default {
  methods: {
    buildFragmentCreateUrl: function(recipe) {
      return "/recipes/" + recipe.id + "/fragments.json"
    },
    buildFragmentUpdateUrl: function(fragment) {
      return "/recipes/" + fragment.recipe_id + "/fragments/" + fragment.id + ".json"
    },
    buildFragmentsPositionsUpdateUrl: function(recipe) {
      return "/recipes/" + recipe.id + "/update_fragments_positions.json"
    }
  }
};
