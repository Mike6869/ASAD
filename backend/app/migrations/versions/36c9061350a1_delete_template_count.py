"""delete template_count

Revision ID: 36c9061350a1
Revises: 254b5fbcb6fa
Create Date: 2025-05-19 04:01:44.636539

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '36c9061350a1'
down_revision = '254b5fbcb6fa'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('project_templates', schema=None) as batch_op:
        batch_op.drop_column('templates_count')

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('project_templates', schema=None) as batch_op:
        batch_op.add_column(sa.Column('templates_count', sa.INTEGER(), autoincrement=False, nullable=False))

    # ### end Alembic commands ###
