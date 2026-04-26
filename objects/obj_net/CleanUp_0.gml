buffer_delete(recv_buf);
if (server_socket >= 0) network_destroy(server_socket);
if (client_socket >= 0) network_destroy(client_socket);
