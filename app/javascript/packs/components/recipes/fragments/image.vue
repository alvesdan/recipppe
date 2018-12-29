<template>
  <div class="fragment-image">
    <vue-dropzone
      :ref="data.id"
      id="dropzone"
      :options="dropzoneOptions"
      v-on:vdropzone-upload-progress="uploadProgress"
      v-on:vdropzone-total-upload-progress="totalUploadProgress"
      v-on:vdropzone-success="uploadSuccess"
      v-on:vdropzone-file-added="fileAdded">
    </vue-dropzone>
    <div class="progress-holder d-none" ref="progressHolder">
      <progress class="progress" value="25" max="100"></progress>
    </div>
    <div class="carousel">
      <template v-for="(image, index) in data.images">
        <input class="carousel-locator" :id="'slide-' + (index + 1)" type="radio" name="carousel-radio" hidden="hidden" :checked="index === 0 ? 'checked' : ''">
      </template>
      <div class="carousel-container">
        <figure v-for="(image, index) in data.images" class="carousel-item" :id="'slide-' + (index + 1)" :data-id="image.id">
          <label class="item-prev btn btn-action btn-lg" :for="'slide-' + (index)" v-if="(index > 0)"><i class="icon icon-arrow-left"></i></label>
          <label class="item-next btn btn-action btn-lg" :for="'slide-' + (index + 2)" v-if="index < (data.images.length - 1)"><i class="icon icon-arrow-right"></i></label>
          <img class="img-responsive rounded" :src="image.url">
          <div class="image-actions">
            <button class="btn btn-sm" :data-id="image.id" @click="removeImage(image.id)"><i class="icon icon-delete"></i></button>
          </div>
        </figure>
      </div>
      <div class="carousel-nav">
        <template v-for="(image, index) in data.images">
          <label class="nav-item text-hide c-hand" :for="'slide-' + (index + 1)">1</label>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
import vue2Dropzone from 'vue2-dropzone'
import Mixins from '../mixins.js'

const classNames = {
  "0": "no-image",
  "1": "one-image",
  "2": "two-images",
  "3": "three-images",
}

export default {
  mixins: [ Mixins ],
  components: {
    vueDropzone: vue2Dropzone
  },
  props: {
    data: Object
  },
  data: function () {
    const CSRFToken = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute('content')

    return {
      dropzoneOptions: {
          url: this.buildFragmentAddImageUrl(this.data),
          thumbnailWidth: 150,
          maxFilesize: 0.5,
          headers: { "X-CSRF-Token": CSRFToken },
          parallelUploads: 1,
          paramName: "fragment_image",
          createImageThumbnails: false,
          maxFiles: 3,
          acceptedFiles: "image/png,image/jpeg",
          dictDefaultMessage: '<i class="fa fa-image"></i> Click here to upload'
      },
      fragmentClass: this.className()
    }
  },
  methods: {
    className: function() {
      return "images-container " + classNames[this.data.images.length]
    },
    uploadProgress: function(file, progress, bytesSent) {
      // console.log("Progress: " + progress)
    },
    uploadSuccess: function(file, response) {
      this.$refs.progressHolder.classList.add("d-none")
      this.data.images = response.images
      this.fragmentClass = this.className()
      this.toggleDropzone()
    },
    totalUploadProgress: function(totaluploadprogress, totalBytes, totalBytesSent) {
      // console.log("Total upload progress: " + totaluploadprogress)
      this.$refs.progressHolder.firstElementChild.value = totaluploadprogress
    },
    toggleDropzone: function() {
      let dropzoneEl = this.$el.getElementsByClassName("vue-dropzone")[0]
      if (this.data.images.length >= 3) {
        dropzoneEl.classList.add("d-none")
      } else {
        dropzoneEl.classList.remove("d-none")
      }
    },
    fileAdded: function(file) {
      this.$refs.progressHolder.firstElementChild.value = 1
      this.$refs.progressHolder.classList.remove("d-none")
    },
    removeImage: function(imageId) {
      let url = this.buildFragmentRemoveImageUrl(this.data),
          params = {
            params: { image_id: imageId }
          }

      this.$http
        .delete(url, params)
        .then(response => {
          let fragment = response.data
          this.data.images = fragment.images
          this.fragmentClass = this.className()
          this.toggleDropzone()
          return
        }, response => {
          console.log("Error while removing image")
          return
        })
    }
  },
  mounted: function() {
    this.toggleDropzone()
  }
}
</script>
