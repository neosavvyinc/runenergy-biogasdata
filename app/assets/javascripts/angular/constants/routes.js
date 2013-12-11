RunEnergy.Dashboard.Constants.constant("constants.Routes", {
    DASHBOARD: {
        USER: {
            READ: "/dashboard/user"
        },
        CUSTOMERS: {
            READ: "/dashboard/customers"
        },
        LOCATIONS: {
            READ: "/dashboard/locations"
        },
        FLARE_DEPLOYMENTS: {
            READ: "/dashboard/flaredeployments"
        },
        FLARE_SPECIFICATIONS: {
            READ: "/dashboard/flarespecifications"
        },
        FLARE_MONITOR_DATA: {
            READ: "/dashboard/flaremonitordata"
        },
        CSV_EXPORT: {
            READ: "/dashboard/flaremonitordata.csv",
            CREATE: "/dashboard/constraints"
        }
    },
    DATA_INPUT: {
        CREATE: "/data_input/create",
        READINGS: "/data_input/readings/:asset_id/:monitor_class_id"
    }
});