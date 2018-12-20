export default {
  methods: {
    buildFragmentCreateUrl: function(recipe) {
      return "/recipes/" + recipe.id + "/fragments/"
    },
    buildFragmentUpdateUrl: function(fragment) {
      return "/recipes/" + fragment.recipe_id + "/fragments/" + fragment.id
    }
  }
};
