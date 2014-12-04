var WebDriver = require('selenium-node-webdriver'),
    fs = require('fs'),
    args = process.argv.slice(2),
    config = {
        url: args[0],
        iterations: args[1] || 50,
        delay: args[2] || 200
    };

console.info('using URL:',config.url, 'for', config.iterations, 'iterations. With',config.delay,'ms between tabs');

function pad(n, width, z) {
  z = z || '0';
  n = n + '';
  return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}

function writeFile (data, num) {
    fs.writeFileSync('./screenshots/'+pad(num, 3)+'.png', new Buffer(data,'base64'), 'binary');
}

WebDriver().
    then(function (driver) {
        driver.get(config.url).
            then(function () {
                driver.findElement(driver.webdriver.By.id('bbccookies-continue-button')).click();
                return driver.sleep(500)
            }).then (function () {
                (function runner(count) {
                    if (count > config.iterations) {
                        driver.quit();
                        return;
                    }
                    driver.takeScreenshot().then(function(data) {
                        writeFile(data, count)
                        new driver.webdriver.ActionSequence(driver).sendKeys(driver.webdriver.Key.TAB).perform()
                        setTimeout(function () {
                            runner(++count);
                        }, config.delay)
                    });
                })(0)
            });
    });
