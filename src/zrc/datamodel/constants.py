from djchoices import ChoiceItem, DjangoChoices


class RolOmschrijving(DjangoChoices):
    adviseur = ChoiceItem('Adviseur', 'Adviseur')
    behandelaar = ChoiceItem('Behandelaar', 'Behandelaar')
    belanghebbende = ChoiceItem('Belanghebbende', 'Belanghebbende')
    beslisser = ChoiceItem('Beslisser', 'Beslisser')
    initiator = ChoiceItem('Initiator', 'Initiator')
    klantcontacter = ChoiceItem('Klantcontacter', 'Klantcontacter')
    zaakcoordinator = ChoiceItem('Zaakcoördinator', 'Zaakcoördinator')


class RolOmschrijvingGeneriek(RolOmschrijving):
    medeinitiator = ChoiceItem('Mede-initiator', 'Mede-initiator')
