var dashboardActions = require('../../_shared/shared/dashboard-actions');

describe('should have all the correct filters and options available for the user type', function () {

    it('Should be able to select the required filters for display', function () {
        dashboardActions.filters("Lemmy Kilmister", "Hammersmith Odeum", "Amplifier Volume");
    });

    it('Should have the sections for the location and monitor class', function () {
        //Not yet implemented
    });

    it('Should have the assets for the location and monitor class', function () {
        dashboardActions.assetDropdown.click();
        dashboardActions.assetDropdown.element.all(by.tagName('a')).then(function (links) {
            expect(links.length).toEqual(5);
            expect(links[1].getText()).toEqual("E String");
            expect(links[2].getText()).toEqual("A String");
            expect(links[3].getText()).toEqual("D String");
            expect(links[4].getText()).toEqual("G String");
        });
    });

});