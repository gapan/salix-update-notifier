/*
 * salix-update-notifier.c
 */

#include <gtk/gtk.h>
#include <locale.h>
#include <libintl.h>
#include <stdlib.h>

#define _(STRING) gettext(STRING)
#define GETTEXT_PACKAGE "salix-update-notifier"
#define LOCALEDIR "/usr/share/locale"

typedef struct {
    GtkWidget *window;
    GtkWidget *system_button;
    GtkWidget *user_button;
} AppWidgets;

/* Create button content with icon and label */
static GtkWidget* create_button_content(const gchar *title, const gchar *icon_name) {
    GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
    GtkIconTheme *icon_theme = gtk_icon_theme_get_default();
    GtkWidget *image = NULL;
    GError *error = NULL;

    GdkPixbuf *pixbuf = gtk_icon_theme_load_icon(icon_theme, icon_name, 256, 0, &error);
    if (pixbuf) {
        image = gtk_image_new_from_pixbuf(pixbuf);
        g_object_unref(pixbuf);
    } else {
        /* Fallback icon */
        image = gtk_image_new_from_icon_name("dialog-information", GTK_ICON_SIZE_DIALOG);
        if (error) g_error_free(error);
    }

    GtkWidget *label = gtk_label_new(NULL);
    gchar *markup = g_markup_printf_escaped("<span size='large' weight='bold'>%s</span>", title);
    gtk_label_set_markup(GTK_LABEL(label), markup);
    g_free(markup);

    gtk_box_pack_start(GTK_BOX(vbox), image, TRUE, TRUE, 0);
    gtk_box_pack_start(GTK_BOX(vbox), label, FALSE, FALSE, 0);

    return vbox;
}

/* Button handlers */
static void on_system_clicked(GtkWidget *widget, gpointer data) {
    exit(1);
}

static void on_user_clicked(GtkWidget *widget, gpointer data) {
    exit(2);
}

int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);

    setlocale(LC_ALL, "");
    bindtextdomain(GETTEXT_PACKAGE, LOCALEDIR);
    textdomain(GETTEXT_PACKAGE);

    AppWidgets *app = g_slice_new(AppWidgets);

    app->window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(app->window), _("Salix Update Manager"));
    gtk_container_set_border_width(GTK_CONTAINER(app->window), 20);
    gtk_window_set_position(GTK_WINDOW(app->window), GTK_WIN_POS_CENTER);
    gtk_window_set_icon_name(GTK_WINDOW(app->window), "salix-update-manager");

    GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
    gtk_container_add(GTK_CONTAINER(app->window), vbox);

    gchar *label_text = g_strdup_printf(
        "<span size='large' weight='bold'>%s</span>\n\n<span weight='bold'>%s</span> %s\n\n<span weight='bold'>%s</span> %s",
        _("Please choose the installation you would like to update."),
        _("System:"),
        _("Update Salix system packages as well as the Flatpak system installation."),
        _("User:"),
        _("Update your current user's Flatpak installation only.")
    );

    GtkWidget *label = gtk_label_new(NULL);
    gtk_label_set_markup(GTK_LABEL(label), label_text);
    gtk_widget_set_margin_bottom(label, 20);
    g_free(label_text);

    gtk_box_pack_start(GTK_BOX(vbox), label, FALSE, FALSE, 0);

    GtkWidget *hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 20);
    gtk_box_set_homogeneous(GTK_BOX(hbox), TRUE);
    gtk_box_pack_start(GTK_BOX(vbox), hbox, TRUE, TRUE, 0);

    /* System button */
    app->system_button = gtk_button_new();
    GtkWidget *system_box = create_button_content(_("System"), "applications-system");
    gtk_container_add(GTK_CONTAINER(app->system_button), system_box);
    gtk_widget_set_size_request(app->system_button, 300, 300);
    g_signal_connect(app->system_button, "clicked", G_CALLBACK(on_system_clicked), NULL);
    gtk_box_pack_start(GTK_BOX(hbox), app->system_button, TRUE, TRUE, 0);

    /* User button */
    app->user_button = gtk_button_new();
    GtkWidget *user_box = create_button_content(_("User"), "users");
    gtk_container_add(GTK_CONTAINER(app->user_button), user_box);
    gtk_widget_set_size_request(app->user_button, 300, 300);
    g_signal_connect(app->user_button, "clicked", G_CALLBACK(on_user_clicked), NULL);
    gtk_box_pack_start(GTK_BOX(hbox), app->user_button, TRUE, TRUE, 0);

    g_signal_connect(app->window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    gtk_widget_show_all(app->window);
    gtk_main();

    g_slice_free(AppWidgets, app);
    return 0;
}

