// vim:et:sta:sts=4:sw=4:ts=8:tw=79:

#include <gtk/gtk.h>
#include <libintl.h>
#include <locale.h>

#ifndef GETTEXT_PACKAGE
#define GETTEXT_PACKAGE "salix-update-notifier"
#endif

#ifndef LOCALEDIR
#define LOCALEDIR "/usr/share/locale"
#endif

int main(int argc, char *argv[]) {
    GtkWidget *dialog;
    gint response;

    // Setup gettext
    setlocale(LC_ALL, "");
    bindtextdomain(GETTEXT_PACKAGE, LOCALEDIR);
    textdomain(GETTEXT_PACKAGE);

    // Initialize GTK
    gtk_init(&argc, &argv);


    // The message has multiple lines. Let's put them in separate strings.
    const char *p1 = gettext("Package updates are available for your system.");
    const char *p2 = gettext("Selecting OK will perform the updates using gslapt. "
                             "Root user privileges will be required in order to do that.");
    const char *p3 = gettext("Proceed with updating?");
    char *message = g_strdup_printf("%s\n\n%s\n\n%s", p1, p2, p3);

    // Create a question dialog
    dialog = gtk_message_dialog_new(
        NULL,
        GTK_DIALOG_MODAL,
        GTK_MESSAGE_QUESTION,
        GTK_BUTTONS_YES_NO,
        "%s",
        gettext(message)
    );

    gtk_window_set_title(GTK_WINDOW(dialog),
                         gettext("Install package updates?"));

    // Use themed icon name instead of explicit path
    gtk_window_set_icon_name(GTK_WINDOW(dialog), "update-notifier");

    // Run dialog
    response = gtk_dialog_run(GTK_DIALOG(dialog));

    gtk_widget_destroy(dialog);

    // Return codes:
    // 0 = yes, 1 = no or closed
    if (response == GTK_RESPONSE_YES)
        return 0;
    else
        return 1;
}

