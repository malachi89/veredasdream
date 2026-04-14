if (variable_instance_exists(id, "notifications")) {
    if (ds_exists(notifications, ds_type_list)) {
        ds_list_destroy(notifications);
    }
}
