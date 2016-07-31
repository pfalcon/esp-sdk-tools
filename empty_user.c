// Placeholder file which defines dummy implementations
// for symbols not defined in SDK objects.

unsigned char default_certificate[0];
unsigned int default_certificate_len = 0;
unsigned char default_private_key[0];
unsigned int default_private_key_len = 0;

void user_init(void)
{
}

int user_rf_cal_sector_set(void)
{
    return 1024 - 5;
}
