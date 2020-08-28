var config = {
    defaults: {
        standard: 'WCAG2AA',
        // ignore issue with role=presentation on start button
        ignore: ["WCAG2AA.Principle1.Guideline1_3.1_3_1.F92,ARIA4"],
        timeout: 20000,
        wait: 2500,
        chromeLaunchConfig: {
            args: [
                "--no-sandbox"
            ]
        }
    },
    urls: [
        '${BASE_URL}?home_page',
        {
            "url": "${BASE_URL}?cookie_control",
            "actions": [
                "wait for element #ccc-dismiss-button to be visible",
                "click element #ccc-dismiss-button"
            ]
        },
        '${BASE_URL}/refunds/scenarios',
        '${BASE_URL}/refunds/details',
        '${BASE_URL}/vehicles/enter_details',
        {
            "url": '${BASE_URL}/vehicles/enter_details?caz-selection',
            "actions": [
                "set field #vrn to CAS300",
                "click element #registration-country-1",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-1 to be visible",
                "click element #confirm-vehicle-1",
                "click element input[type=submit]",
                "wait for element #birmingham to be visible"
            ]
        },
        {
            "url": '${BASE_URL}/vehicles/enter_details?confirm-terms-agreement',
            "actions": [
                "set field #vrn to CAS300",
                "click element #registration-country-1",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-1 to be visible",
                "click element #confirm-vehicle-1",
                "click element input[type=submit]",
                "wait for element #birmingham to be visible",
                "click element #birmingham",
                "click element input[type=submit]",
                "wait for element #confirm-exempt to be visible",
            ]
        },
        {
            "url": '${BASE_URL}/vehicles/enter_details?select-date',
            "actions": [
                "set field #vrn to CAS300",
                "click element #registration-country-1",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-1 to be visible",
                "click element #confirm-vehicle-1",
                "click element input[type=submit]",
                "wait for element #birmingham to be visible",
                "click element #birmingham",
                "click element input[type=submit]",
                "wait for element #confirm-exempt to be visible",
                "click element #confirm-exempt",
                "click element input[type=submit]",
                "wait for element #date-6 to be visible",
                "click element #date-6",
            ]
        },
        {
            "url": '${BASE_URL}/vehicles/enter_details?payment_summary',
            "actions": [
                "set field #vrn to CAS300",
                "click element #registration-country-1",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-1 to be visible",
                "click element #confirm-vehicle-1",
                "click element input[type=submit]",
                "wait for element #birmingham to be visible",
                "click element #birmingham",
                "click element input[type=submit]",
                "wait for element #confirm-exempt to be visible",
                "click element #confirm-exempt",
                "click element input[type=submit]",
                "wait for element #date-0 to be visible",
                "click element #date-0",
                "click element input[type=submit]"
            ]
        },
        {
            "url": '${BASE_URL}/vehicles/enter_details?non_dvla_vehicles',
            "actions": [
                "set field #vrn to CU57123",
                "click element #registration-country-2",
                "click element input[type=submit]",
                "wait for element #confirm-registration to be visible",
                "click element #confirm-registration",
                "click element input[type=submit]"
            ]
        },
        {
            "url": '${BASE_URL}/vehicles/enter_details?dvla_vehicles',
            "actions": [
                "set field #vrn to CAS300",
                "click element #registration-country-2",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-1 to be visible",
                "click element #confirm-vehicle-1",
                "click element input[type=submit]",
            ]
        },
        {
            "url": '${BASE_URL}/vehicles/enter_details?unrecognised_vehicles',
            "actions": [
                "set field #vrn to ZZZ9988",
                "click element #registration-country-1",
                "click element input[type=submit]"
            ]
        },
        {
            "url": '${BASE_URL}/vehicles/enter_details?incorrect_details',
            "actions": [
                "set field #vrn to CAS300",
                "click element #registration-country-1",
                "click element input[type=submit]",
                "wait for element #confirm-vehicle-2 to be visible",
                "click element #confirm-vehicle-2",
                "click element input[type=submit]"
            ]
        }
    ]
};

/**
 * Simple method to replace nested URLs in a pa11y configuration definition
 */
function replacePa11yBaseUrls(urls, defaults) {
    console.error('BASE_URL:', process.env.BASE_URL);
    //Iterate existing urls object from configuration
    for (var idx = 0; idx < urls.length; idx++) {
        if (typeof urls[idx] === 'object') {
            // If configuration object in URLs is a further nested object, replace inner url field value
            var nestedObject = urls[idx]
            nestedObject['url'] = nestedObject['url'].replace('${BASE_URL}', process.env.BASE_URL)
            urls[idx] = nestedObject;
        } else {
            // Otherwise replace simple string (see pa11y configuration guidance)
            urls[idx] = urls[idx].replace('${BASE_URL}', process.env.BASE_URL);
        }
    }

    result = {
        defaults: defaults,
        urls: urls
    }

    console.log('\n')
    console.log('Generated pa11y configuration:\n')
    console.log(result)

    return result
}

module.exports = replacePa11yBaseUrls(config.urls, config.defaults);
