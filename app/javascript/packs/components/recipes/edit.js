/* eslint no-console: 0 */
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import VueResource from 'vue-resource'
import draggable from 'vuedraggable'
import Mixins from './mixins.js'
import FragmentHeader from './fragments/header.vue'
import FragmentParagraph from './fragments/paragraph.vue'
import FragmentList from './fragments/list.vue'

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
  const defaultContent = {
    header: "",
    paragraph: "",
    ordered_list: "<li></li>",
    unordered_list: "<li></li>"
  }

  const app = new Vue({
    el: '#recipe_edit',
    data: {
      recipe: recipeData,
      fragments: recipeFragments,
      fragmentHeader: FragmentHeader,
      fragmentParagraph: FragmentParagraph,
      fragmentList: FragmentList,
      fragmentSortableList: null,
      draggableOptions: {
        draggable: ".fragment",
        handle: ".draggable-handle"
      },
      allowAutoFocus: true
    },
    methods: {
      onDraggableEnd: function(event) {
        let htmlFragments = this.$el.getElementsByClassName("fragment"),
            positions = {},
            index = 0

        for (let fragment of htmlFragments) {
          positions[fragment.dataset.id] = { position: index }
          index++
        }
        this.updateFragmentsPositions(positions)
      },
      updateFragmentsPositions: function(positions) {
        let url = this.buildFragmentsPositionsUpdateUrl(this.recipe)

        this.$http
          .patch(url, { fragments: positions })
          .then(response => {
            // Positions have been updated
          }, response => {
            console.log("Error while creating fragment")
            return
          })
      },
      addFragment: function(event) {
        let type = event.target.dataset.type,
            url = this.buildFragmentCreateUrl(this.recipe),
            position = this.fragments.length,
            params = {
              fragment: {
                fragment_type: type,
                html_content: defaultContent[type],
                position: position
              }
            }

        this.$http
          .post(url, params)
          .then(response => {
            let fragment = response.data
            this.fragments.push(fragment)
            return
          }, response => {
            console.log("Error while creating fragment")
            return
          })
      },
      updateFragment: function(fragment) {
        let url = this.buildFragmentUpdateUrl(fragment.data),
            params = {
              fragment: {
                html_content: fragment.data.html_content
              }
            }

        this.$http
          .patch(url, params)
          .then(response => {
            fragment.data.updated_at = response.data.updated_at
            return
          }, response => {
            console.log("Error while updating fragment")
            return
          })
      },
      removeFragment: function(fragment) {
        let previous = fragment.$el.parentElement.previousElementSibling,
            index = this.fragments.indexOf(fragment.data),
            url = this.buildFragmentDeleteUrl(fragment.data)

        this.allowAutoFocus = false
        this.fragments.splice(index, 1)

        this.$http
          .delete(url)
          .then(response => {
            // Fragment deleted
            if (previous) {
              let items = previous.querySelectorAll("[contenteditable=true]"),
                  lastItem = items[items.length - 1]
              this.placeCareAtEndOf(lastItem)
            }
            this.allowAutoFocus = true
            return
          }, response => {
            console.log("Error while removing fragment")
            return
          })
      }
    },
    components: {
      draggable
    }
  })
})
