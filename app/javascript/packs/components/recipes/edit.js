/* eslint no-console: 0 */
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import VueResource from 'vue-resource'
import Mixins from './mixins.js'
import FragmentHeader from './fragments/header.vue'
import FragmentParagraph from './fragments/paragraph.vue'

Vue.use(TurbolinksAdapter)
Vue.use(VueResource)
Vue.mixin(Mixins)

document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-Token'] =
    document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute('content')

  const dataset = document.getElementById('recipe_edit').dataset
  const recipeData = JSON.parse(dataset.recipe)
  const recipeFragments = JSON.parse(dataset.fragments)

  const app = new Vue({
    el: '#recipe_edit',
    data: {
      recipe: recipeData,
      fragments: recipeFragments,
      fragmentHeader: FragmentHeader,
      fragmentParagraph: FragmentParagraph
    },
    methods: {
      addFragment: function(event) {
        let type = event.target.dataset.type
        let url = this.buildFragmentCreateUrl(this.recipe)
        let position = this.fragments.length

        this.$http
          .post(url, {
            fragment: {
              fragment_type: type,
              html_content: "",
              position: position
            }
          })
          .then(response => {
            let fragment = response.data
            this.fragments.push(fragment)
            return
          }, response => {
            console.log("Error while creating fragment")
            return
          })
      }
    },
    //components: [ DynamicFragment ]
  })
})
