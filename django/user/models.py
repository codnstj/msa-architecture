from django.db import models

# Create your models here.
class User:
    userEmail = models.CharField(max_length=255)
    userName = models.CharField(max_length=20)
    profileImage = models.CharField(max_length=100)
    joinDate = models.DateField()