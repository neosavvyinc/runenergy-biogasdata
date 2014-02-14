var MonitorClass = require('../_shared/admin/monitor-class');

describe('delete the monitor classes needed for scenarios', function () {

    var monitorClass = new MonitorClass();

    it('Should delete the monitor class', function () {
        monitorClass.deleteMonitorClass("Amplifier Volume");
    });

});