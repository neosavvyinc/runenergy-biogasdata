var MonitorClass = require('../_shared/admin/monitor-class');

describe('create the monitor classes needed for scenarios', function () {

    var monitorClass = new MonitorClass();

    it('Should create the use', function () {
        monitorClass.create("Amplifier Volume", "Hammersmith Odeum");
    });

});