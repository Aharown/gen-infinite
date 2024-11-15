import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.carousel .post-video').forEach((video) => {
    video.addEventListener('click', (event) => {
      event.stopPropagation(); // Prevent carousel navigation on video interaction
      if (video.paused) {
        video.play(); // Play the video if it's paused
      } else {
        video.pause(); // Pause the video if it's playing
      }
    });
  });

  // Listen for 'play' event and pause the carousel
  document.querySelectorAll('.carousel .post-video').forEach((video) => {
    video.addEventListener('play', (event) => {
      const carousel = event.target.closest('.carousel');
      if (carousel) {
        const bootstrapCarousel = bootstrap.Carousel.getInstance(carousel);
        bootstrapCarousel.pause(); // Pause carousel when video plays
      }
    });

    video.addEventListener('pause', (event) => {
      const carousel = event.target.closest('.carousel');
      if (carousel) {
        const bootstrapCarousel = bootstrap.Carousel.getInstance(carousel);
        bootstrapCarousel.cycle(); // Resume carousel after video pauses
      }
    });
  });
});

export { application }
