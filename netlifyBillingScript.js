let buildMinutes = 0;
for (const rect of document.querySelectorAll('rect')) {
    if (rect.ariaLabel?.includes("Aug") && rect.ariaLabel.endsWith("m")) {
        console.log('label', rect.ariaLabel);
        const buildMinutesString = rect.ariaLabel.match(/\s([0-9]+)m/)[1];
        const buildMinutesOnDay = parseInt(buildMinutesString);
        console.log('adding', { buildMinutes, buildMinutesOnDay });
        buildMinutes += buildMinutesOnDay;
    }
}

console.log('Build Minutes: ' + buildMinutes);
const usage = (buildMinutes - 1000) / 500;
console.log('Usage billing: ' + usage);
