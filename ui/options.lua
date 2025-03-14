local options = {
  name = "options",
  title = "Options",
  items = {
      {
          name = "Fullscreen",
          type = "checkbox",
          variable = "fullscreen"
      },
      {
          name = "Resolution",
          type = "dropdown",
          options = {
              { name = "800x600", value = "800x600" },
              { name = "1024x768", value = "1024x768" },
              { name = "1280x720", value = "1280x720" },
              { name = "1366x768", value = "1366x768" },
              { name = "1600x900", value = "1600x900" },
              { name = "1920x1080", value = "1920x1080" },
              { name = "2560x1440", value = "2560x1440" },
              { name = "2560x1600", value = "2560x1600" },
              { name = "3840x2160", value = "3840x2160" },
              { name = "3840x2400", value = "3840x2400" },
              { name = "4096x2160", value = "4096x2160" },
              { name = "4096x2560", value = "4096x2560" }
          },
          variable = "resolution"
      },
      {
          name = "Language",
          type = "dropdown",
          options = {
              { name = "English", value = "en" },
              { name = "Română", value = "ro" }
          },
          variable = "language"
      },
      {
          name = "Master Volume",
          type = "slider",
          min = 0,
          max = 100,
          default = 100,
          step = 1,
          variable = "master_volume"
      },
      {
          name = "Music Volume",
          type = "slider",
          min = 0,
          max = 100,
          default = 100,
          step = 1,
          variable = "music_volume"
      },
      {
          name = "Back",
          action = "back"
      }
  }
}

return options