#include <gtk/gtk.h>
#include <stdlib.h>
#include <locale.h>
#include <libintl.h>

#define _(STRING) gettext(STRING)
#define GETTEXT_PACKAGE "salix-update-notifier"
#define LOCALEDIR "/usr/share/locale"

static void close_app(GtkMenuItem *item, gpointer user_data) {
    gtk_main_quit();
}

static void make_menu(GtkStatusIcon *status_icon, guint button, guint activate_time, gpointer user_data) {
    GtkWidget *menu;
    GtkWidget *close_item;

    menu = gtk_menu_new();

    // "Close" menu item with stock icon
    close_item = gtk_image_menu_item_new_from_stock(GTK_STOCK_CLOSE, NULL);
    g_signal_connect(close_item, "activate", G_CALLBACK(close_app), NULL);
    gtk_menu_shell_append(GTK_MENU_SHELL(menu), close_item);

    gtk_widget_show_all(menu);
    gtk_menu_popup(GTK_MENU(menu), NULL, NULL, NULL, NULL, button, activate_time);
}

static void on_left_click(GtkStatusIcon *status_icon, gpointer user_data) {
    gtk_main_quit();
}

int main(int argc, char **argv) {
    GtkStatusIcon *icon;

    // Initialize GTK
    gtk_init(&argc, &argv);

    // Internationalization
    setlocale(LC_ALL, "");
    bindtextdomain(GETTEXT_PACKAGE, LOCALEDIR);
    textdomain(GETTEXT_PACKAGE);

    // Create tray icon
    icon = gtk_status_icon_new_from_icon_name("updates-notifier");
    gtk_status_icon_set_tooltip_text(icon, _("Package updates are available."));
    g_signal_connect(icon, "popup-menu", G_CALLBACK(make_menu), NULL);
    g_signal_connect(icon, "activate", G_CALLBACK(on_left_click), NULL);

    // Run GTK main loop
    gtk_main();

    return 0;
}

