import { exec } from "resource:///com/github/Aylur/ags/utils.js";
import { monitorFile } from "resource:///com/github/Aylur/ags/utils.js";
import App from "resource:///com/github/Aylur/ags/app.js";

import { Bar } from "./Windows/Bar.js";
import { ActivityCenter } from "./Windows/ActivityCenter.js";

// main scss file
const scss = `${App.configDir}/Style/style.scss`;

// target css file
const css = `${App.configDir}/Style/style.css`;

// Generate css
exec(`sassc ${scss} ${css}`);

monitorFile(`${App.configDir}/Style/_colors.scss`, function () {
    exec(`sassc ${scss} ${css}`);
    App.resetCss();
    App.applyCss(`${App.configDir}/Style/style.css`);
});

App.config({
    style: css,
    windows: [Bar(0), Bar(1), ActivityCenter()],
});

