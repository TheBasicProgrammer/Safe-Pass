from django.db import models

# Create your models here.
class AppSettings(models.Model):
    # class ExportFormats(models.TextChoices):
    #     CSV = '.csv'
    #     XLS = '.xls/.xlsx'

    # enable_mfa = models.BooleanField(default=True)
    session_timeout = models.IntegerField(default=60)
    # enable_visitor_notifs = models.BooleanField(default=True)
    # enable_alerts = models.BooleanField(default=True)
    enable_scheduled_reminders = models.BooleanField(default=False)
    max_visitors_per_day = models.IntegerField(default=50)
    max_visit_duration = models.IntegerField(default=120)
    # export_format = models.CharField(max_length=255, choices=ExportFormats.choices, default=ExportFormats.CSV)

    def __str__(self):
        return str(self.id)
    
    class Meta:
        verbose_name = 'App Setting'
        verbose_name_plural = 'App Settings'