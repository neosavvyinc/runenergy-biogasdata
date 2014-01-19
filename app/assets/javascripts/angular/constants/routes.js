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
    APPLICATION_STATE: {
        LAST_URL_PARAMS: "/application_state/last_url_params"
    },
    DATA_INPUT: {
        CREATE: "/data_input/create",
        READINGS: "/data_input/readings/:asset_id/:monitor_class_id",
        IMPORT: "/data_input/import",
        COMPLETE_IMPORT: "/data_input/complete_import"
    },
    ANALYSIS: {
        READINGS: "/data_analysis/readings/site/:site_id/monitorclass/:monitor_class_id",
        MONITOR_POINTS: "/data_analysis/monitor_points/:asset_id"
    }
});