from rest_framework.permissions import AllowAny


class PublicMixin:
    permission_classes = [AllowAny]

    @property
    def model(self):
        """
        Retrieve model used in serializer
        """
        return self.serializer_class.Meta.model

    def get_queryset(self):
        """
        Get objects
        """
        if self.queryset:
            return self.queryset
        return self.model.objects.all()
