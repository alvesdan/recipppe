<template>
  <div class="fragment-menu">
    <div class="popover popover-left">
      <a class="open-menu"><i class="icon icon-more-vert"></i></a>
      <div class="popover-container">
        <div class="card">
          <div class="card-header">
            {{ fragment.fragment_type }}: {{ fragment.id }}
          </div>
          <div class="card-body">
            <button class="btn" v-on:click="removeFragmentFromMenu()"><i class="icon icon-delete"></i> Remove</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Mixins from '../mixins.js'
export default {
  mixins: [ Mixins ],
  props: {
    fragment: Object
  },
  methods: {
    removeFragmentFromMenu: function() {
      this.$root.removeFragment({ data: this.fragment })
    }
  }
}
</script>
