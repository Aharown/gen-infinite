import { Application } from "@hotwired/stimulus"

const application = Application.start()

application.debug = false
window.Stimulus = application

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.carousel .post-video').forEach((video) => {
    video.addEventListener('click', (event) => {
      event.stopPropagation();
      if (video.paused) {
        video.play();
      } else {
        video.pause();
      }
    });
  });

  document.querySelectorAll('.carousel .post-video').forEach((video) => {
    video.addEventListener('play', (event) => {
      const carousel = event.target.closest('.carousel');
      if (carousel) {
        const bootstrapCarousel = bootstrap.Carousel.getInstance(carousel);
        bootstrapCarousel.pause();
      }
    });

    video.addEventListener('pause', (event) => {
      const carousel = event.target.closest('.carousel');
      if (carousel) {
        const bootstrapCarousel = bootstrap.Carousel.getInstance(carousel);
        bootstrapCarousel.cycle(); 
      }
    });
  });
});

export { application }
