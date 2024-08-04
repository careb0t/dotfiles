import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';

import { Bar } from './Windows/Bar.js';

// Add icons in assets to icon set
//Gtk.IconTheme.get_default().append_search_path(`${App.configDir}/assets`);
App.addIcons(`${App.configDir}/assets`)

// main scss file
const scss = `${App.configDir}/Style/style.scss`

// target css file
const css = `${App.configDir}/Style/style.css`

// Generate css
exec(`sassc ${scss} ${css}`)

monitorFile(
    `${App.configDir}/Style/_colors.scss`,
    function() {
        exec(`sassc ${scss} ${css}`)
        App.resetCss();
        App.applyCss(`${App.configDir}/Style/style.css`);
    },
);

App.config({
    style: css, 
    windows: [
        Bar(0),
        Bar(1),
    ],
});
