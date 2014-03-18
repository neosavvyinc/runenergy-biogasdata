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
        CREATE_MONITOR_POINT: "/data_input/create/monitor_point",
        READINGS: "/data_input/readings/site/:site_id/monitorclass/:monitor_class_id",
        LOCATIONS_MONITOR_CLASS: "/data_input/locations_monitor_class/site/:site_id/monitor_class/:monitor_class_id",
        ASSETS: "/data_input/assets/site/:site_id/monitorclass/:monitor_class_id",
        IMPORT: "/data_input/import",
        COMPLETE_IMPORT: "/data_input/complete_import",
        APPROVE_LIMIT_BREAKING_SET: "/data_input/approve_limit_breaking_set"
    },
    ANALYSIS: {
        READINGS: "/data_analysis/readings/site/:site_id/monitorclass/:monitor_class_id",
        UPDATE_READING: "/data_analysis/readings/:id",
        MONITOR_POINTS: "/data_analysis/monitor_points/:asset_id"
    },
    DATA_COLLISION: {
        RESOLVE: "/data_collision/resolve"
    }
});